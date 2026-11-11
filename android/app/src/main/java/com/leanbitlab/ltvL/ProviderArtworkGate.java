package com.leanbitlab.ltvL;

import java.util.concurrent.ConcurrentHashMap;

/**
 * Limits when the launcher asks other apps' content providers for artwork.
 *
 * <p>Opening a {@code content://} poster runs code inside the app that published it. Some
 * providers decode and re-encode artwork on their own main thread, so a request made while that
 * app is in the foreground can freeze it until Android reports an ANR. Watch Next changes are
 * usually published by the app the user is currently using, so the launcher only opens provider
 * artwork while the launcher itself is resumed, and at most one request at a time per provider.
 * Deferred requests return null, which is not cached, so they are retried on the next refresh.
 */
final class ProviderArtworkGate {
    private volatile boolean resumed;
    private final ConcurrentHashMap<String, Object> providerLocks = new ConcurrentHashMap<>();

    void setResumed(boolean resumed) {
        this.resumed = resumed;
    }

    /** True for artwork served by another app's content provider. */
    static boolean isProviderUri(String uri) {
        return uri != null && uri.startsWith("content://");
    }

    /** The provider authority of a {@code content://} URI, or an empty string if it has none. */
    static String authority(String uri) {
        int start = "content://".length();
        int end = start;
        while (end < uri.length() && "/?#".indexOf(uri.charAt(end)) < 0) end++;
        return uri.substring(start, end);
    }

    /**
     * Runs {@code loader} directly for non-provider artwork. Provider artwork is loaded only
     * while the launcher is resumed, one request at a time per provider; otherwise returns null.
     */
    byte[] load(String uri, PosterCache.Loader loader) {
        if (!isProviderUri(uri)) return loader.load();
        if (!resumed) return null;
        synchronized (lockFor(authority(uri))) {
            // Re-check: the launcher may have been left while this request waited its turn.
            if (!resumed) return null;
            return loader.load();
        }
    }

    private Object lockFor(String authority) {
        Object lock = providerLocks.get(authority);
        if (lock == null) {
            Object created = new Object();
            lock = providerLocks.putIfAbsent(authority, created);
            if (lock == null) lock = created;
        }
        return lock;
    }
}
