package com.leanbitlab.ltvL;

import android.accessibilityservice.AccessibilityService;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ResolveInfo;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.os.PowerManager;
import android.os.SystemClock;
import android.util.Log;
import android.view.KeyEvent;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;
import java.util.HashSet;
import java.util.Set;

public class LauncherAccessibilityService extends AccessibilityService {
    private final Handler handler = new Handler(Looper.getMainLooper());
    private final WakeHomePolicy wakePolicy = new WakeHomePolicy();
    private final Set<String> otherHomeActivities = new HashSet<>();
    private boolean receiverRegistered;
    private final Runnable returnAfterWake = this::maybeReturnAfterWake;
    private final BroadcastReceiver screenReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            handler.removeCallbacks(returnAfterWake);
            if (Intent.ACTION_SCREEN_OFF.equals(intent.getAction())) {
                wakePolicy.screenOff();
            } else if (Intent.ACTION_SCREEN_ON.equals(intent.getAction())) {
                wakePolicy.screenOn(SystemClock.elapsedRealtime());
                if (BuildConfig.DEBUG) Log.d("LTvHome", "Standby wake received");
                // Let the resumed app/window settle before deciding to redirect.
                handler.postDelayed(returnAfterWake, 500);
            }
        }
    };

    @Override
    protected void onServiceConnected() {
        super.onServiceConnected();
        otherHomeActivities.clear();
        Intent home = new Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME);
        for (ResolveInfo info : getPackageManager().queryIntentActivities(home, 0)) {
            if (info.activityInfo != null && !getPackageName().equals(info.activityInfo.packageName)
                    && !"com.android.tv.settings".equals(info.activityInfo.packageName)
                    && !"com.google.android.tungsten.setupwraith".equals(info.activityInfo.packageName)
                    && !info.activityInfo.name.endsWith(".FallbackHome")
                    && !info.activityInfo.name.endsWith(".RecoveryActivity")) {
                otherHomeActivities.add(info.activityInfo.packageName + "/" + info.activityInfo.name);
            }
        }
        if (BuildConfig.DEBUG) Log.d("LTvHome", "HOME activities: " + otherHomeActivities);
        if (!receiverRegistered) {
            IntentFilter filter = new IntentFilter(Intent.ACTION_SCREEN_ON);
            filter.addAction(Intent.ACTION_SCREEN_OFF);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                registerReceiver(screenReceiver, filter, Context.RECEIVER_NOT_EXPORTED);
            } else {
                registerReceiver(screenReceiver, filter);
            }
            receiverRegistered = true;
        }
    }

    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        if (event.getEventType() != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED
                || event.getPackageName() == null || event.getClassName() == null) return;
        wakePolicy.windowChanged(event.getPackageName().toString(), event.getClassName().toString());
        if (BuildConfig.DEBUG) Log.d("LTvHome", "Window: " + event.getPackageName() + "/" + event.getClassName());
        handler.removeCallbacks(returnAfterWake);
        handler.postDelayed(returnAfterWake, 500);
    }

    private void maybeReturnAfterWake() {
        if (!wakePolicy.isPending(SystemClock.elapsedRealtime())) return;
        PowerManager power = (PowerManager) getSystemService(POWER_SERVICE);
        AccessibilityNodeInfo root = getRootInActiveWindow();
        String activePackage = null;
        if (root != null) {
            if (root.getPackageName() != null) activePackage = root.getPackageName().toString();
            root.recycle();
        }
        if (BuildConfig.DEBUG) Log.d("LTvHome", "Wake check active package: " + activePackage
                + ", interactive: " + power.isInteractive());
        if (wakePolicy.shouldReturnHome(SystemClock.elapsedRealtime(), power.isInteractive(),
                activePackage, otherHomeActivities)) {
            wakePolicy.completed();
            openHome();
        }
    }

    private void openHome() {
        try {
            startActivity(new Intent(this, MainActivity.class)
                    .setAction(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP));
        } catch (android.content.ActivityNotFoundException | SecurityException e) {
            Log.w("LTvHome", "Could not open launcher", e);
        }
    }

    @Override
    public void onInterrupt() {
        handler.removeCallbacks(returnAfterWake);
        wakePolicy.completed();
    }

    @Override
    public void onDestroy() {
        handler.removeCallbacks(returnAfterWake);
        if (receiverRegistered) unregisterReceiver(screenReceiver);
        receiverRegistered = false;
        super.onDestroy();
    }

    @Override
    protected boolean onKeyEvent(KeyEvent event) {
        if (event.getKeyCode() != KeyEvent.KEYCODE_HOME) return super.onKeyEvent(event);
        if (event.getAction() == KeyEvent.ACTION_DOWN && event.getRepeatCount() == 0) {
            wakePolicy.completed();
            handler.removeCallbacks(returnAfterWake);
            openHome();
        }
        return true;
    }
}
