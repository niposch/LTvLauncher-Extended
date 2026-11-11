package com.leanbitlab.ltvL;

import android.app.Activity;
import android.content.Intent;
import android.content.ClipData;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import androidx.core.content.FileProvider;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import java.io.File;
import java.io.FileInputStream;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/** User-approved self updates; no storage permission or silent installation. */
final class AppUpdateManager {
    private final Activity activity;
    private final MethodChannel channel;
    private final ExecutorService executor = Executors.newSingleThreadExecutor();
    private volatile boolean disposed;
    private boolean installing;

    AppUpdateManager(Activity activity, BinaryMessenger messenger) {
        this.activity = activity;
        channel = new MethodChannel(messenger, "com.niposch.ltvlauncher.extended/updates");
        channel.setMethodCallHandler((call, result) -> {
            switch (call.method) {
                case "info" -> {
                    try {
                        PackageInfo info = activity.getPackageManager().getPackageInfo(activity.getPackageName(), 0);
                        Map<String, Object> map = new HashMap<>();
                        map.put("versionName", info.versionName);
                        map.put("versionCode", version(info));
                        map.put("packageName", activity.getPackageName());
                        map.put("debug", BuildConfig.DEBUG);
                        map.put("canInstall", allowed());
                        map.put("updatePath", updateFile().getAbsolutePath());
                        result.success(map);
                    } catch (Exception e) { result.error("platform", "Cannot read installed version", null); }
                }
                case "allowInstalls" -> {
                    try {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            activity.startActivity(new Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
                                    Uri.parse("package:" + activity.getPackageName())));
                        }
                        result.success(null);
                    } catch (Exception e) { result.error("permission", "Install permission settings unavailable", null); }
                }
                case "install" -> {
                    String digest = call.argument("sha256");
                    Number expected = call.argument("versionCode");
                    if (BuildConfig.DEBUG) { result.error("debug", "Debug builds cannot install release updates", null); }
                    else if (installing) { result.error("busy", "An update is already being verified", null); }
                    else if (digest == null || !digest.matches("[a-f0-9]{64}") || expected == null) {
                        result.error("metadata", "Missing update integrity metadata", null);
                    } else {
                        installing = true;
                        executor.execute(() -> {
                            String failure;
                            try { failure = validate(digest, expected.longValue()); }
                            catch (Exception e) { failure = "integrity"; }
                            final String rejection = failure;
                            activity.runOnUiThread(() -> {
                                installing = false;
                                if (disposed) return;
                                if (rejection != null) { result.error(rejection, "Update verification failed", null); return; }
                                if (!allowed()) { result.success("permissionRequired"); return; }
                                try {
                                    Uri uri = FileProvider.getUriForFile(activity,
                                            activity.getPackageName() + ".updates", updateFile());
                                    Intent intent = new Intent(Intent.ACTION_VIEW)
                                            .setDataAndType(uri, "application/vnd.android.package-archive")
                                            .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                                    intent.setClipData(ClipData.newRawUri("LTv Extended update", uri));
                                    activity.startActivity(intent);
                                    result.success("installerOpened");
                                } catch (Exception e) { result.error("installer", "Android installer unavailable", null); }
                            });
                        });
                    }
                }
                default -> result.notImplemented();
            }
        });
    }

    private boolean allowed() {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.O || activity.getPackageManager().canRequestPackageInstalls();
    }
    private File updateFile() { return new File(activity.getCacheDir(), "launcher-updates/update.apk"); }
    private static long version(PackageInfo info) {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.P ? info.getLongVersionCode() : info.versionCode;
    }
    private static List<String> signatures(Signature[] signatures) {
        List<String> values = new ArrayList<>();
        if (signatures != null) for (Signature signature : signatures) values.add(signature.toCharsString());
        return values;
    }
    private static List<String> currentSigners(PackageInfo info) {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.P && info.signingInfo != null
                ? signatures(info.signingInfo.getApkContentsSigners()) : signatures(info.signatures);
    }
    private static List<String> signerHistory(PackageInfo info) {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.P && info.signingInfo != null && !info.signingInfo.hasMultipleSigners()
                ? signatures(info.signingInfo.getSigningCertificateHistory()) : currentSigners(info);
    }
    private String validate(String expectedHash, long expectedVersion) throws Exception {
        File apk = updateFile();
        if (!apk.isFile() || apk.length() <= 0 || apk.length() > 200L * 1024 * 1024 ||
                !apk.getCanonicalFile().equals(new File(activity.getCacheDir().getCanonicalFile(), "launcher-updates/update.apk"))) return "integrity";
        MessageDigest hash = MessageDigest.getInstance("SHA-256");
        try (FileInputStream stream = new FileInputStream(apk)) {
            byte[] buffer = new byte[65536];
            int count;
            while ((count = stream.read(buffer)) >= 0) {
                if (Thread.currentThread().isInterrupted()) return "cancelled";
                hash.update(buffer, 0, count);
            }
        }
        StringBuilder hex = new StringBuilder();
        for (byte b : hash.digest()) hex.append(String.format("%02x", b & 0xff));
        if (!expectedHash.equals(hex.toString())) { apk.delete(); return "integrity"; }
        PackageManager pm = activity.getPackageManager();
        int flags = Build.VERSION.SDK_INT >= Build.VERSION_CODES.P
                ? PackageManager.GET_SIGNING_CERTIFICATES : PackageManager.GET_SIGNATURES;
        PackageInfo archive = pm.getPackageArchiveInfo(apk.getAbsolutePath(), flags);
        if (archive == null || archive.applicationInfo == null) return "package";
        PackageInfo installed = pm.getPackageInfo(activity.getPackageName(), flags);
        int minimumSdk = Build.VERSION.SDK_INT >= Build.VERSION_CODES.N ? archive.applicationInfo.minSdkVersion : 21;
        return UpdatePackagePolicy.reject(activity.getPackageName(), BuildConfig.DEBUG, version(installed),
                archive.packageName, version(archive), expectedVersion, minimumSdk, Build.VERSION.SDK_INT,
                currentSigners(installed), currentSigners(archive), signerHistory(archive));
    }

    void dispose() { disposed = true; channel.setMethodCallHandler(null); executor.shutdownNow(); }
}
