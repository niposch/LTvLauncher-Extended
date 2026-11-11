package com.leanbitlab.ltvL;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

/** Private URI-keyed poster bytes, shared by HTTP and content-provider requests. */
final class PosterCache {
    interface Loader {
        byte[] load();
    }

    private final File directory;
    private final long maxAgeMillis;
    // Fixed stripes avoid retaining every URI and coalesce simultaneous requests for one image.
    private final Object[] locks = new Object[16];

    PosterCache(File directory, long maxAgeMillis) {
        this.directory = directory;
        this.maxAgeMillis = maxAgeMillis;
        for (int i = 0; i < locks.length; i++) locks[i] = new Object();
    }

    byte[] get(String uri, Loader loader) {
        if (uri == null || !(uri.startsWith("http://") || uri.startsWith("https://")
                || uri.startsWith("content://"))) {
            return loader.load();
        }
        // Retain existing HTTP cache filenames. Provider bytes may have any image format.
        String filename = sha1Hex(uri) + (uri.startsWith("content://") ? ".img" : ".jpg");
        File cached = new File(directory, filename);
        synchronized (lockFor(filename)) {
            if (cached.isFile() && cached.length() > 0 && cached.length() <= Integer.MAX_VALUE
                    && !expired(cached)) {
                try {
                    byte[] bytes = new byte[(int) cached.length()];
                    try (DataInputStream input = new DataInputStream(new FileInputStream(cached))) {
                        input.readFully(bytes);
                    }
                    cached.setLastModified(System.currentTimeMillis());
                    return bytes;
                } catch (IOException ignored) {
                    // A missing/unreadable cache entry is a normal cache miss.
                }
            }
            cached.delete();
            byte[] bytes = loader.load();
            if (bytes == null || bytes.length == 0) return bytes;
            directory.mkdirs();
            File temporary = null;
            try {
                temporary = File.createTempFile("poster-", ".tmp", directory);
                try (FileOutputStream output = new FileOutputStream(temporary)) {
                    output.write(bytes);
                }
                // Publish only complete entries, including if the app is stopped during a write.
                temporary.renameTo(cached);
            } catch (IOException ignored) {
                // Cache storage is optional; still return successfully loaded artwork.
            } finally {
                if (temporary != null) temporary.delete();
            }
            return bytes;
        }
    }

    void prune() {
        File[] files = directory.listFiles();
        if (files == null) return;
        for (File file : files) {
            synchronized (lockFor(file.getName())) {
                if (expired(file)) file.delete();
            }
        }
    }

    private boolean expired(File file) {
        return file.lastModified() < System.currentTimeMillis() - maxAgeMillis;
    }

    private Object lockFor(String filename) {
        return locks[(filename.hashCode() & Integer.MAX_VALUE) % locks.length];
    }

    private static String sha1Hex(String value) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-1");
            StringBuilder result = new StringBuilder();
            for (byte b : digest.digest(value.getBytes(StandardCharsets.UTF_8))) {
                result.append(String.format("%02x", b));
            }
            return result.toString();
        } catch (Exception e) {
            return Integer.toHexString(value.hashCode());
        }
    }
}
