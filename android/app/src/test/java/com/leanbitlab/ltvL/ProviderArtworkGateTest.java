package com.leanbitlab.ltvL;

import org.junit.Test;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import static org.junit.Assert.*;

public class ProviderArtworkGateTest {
    private static final String PROVIDER = "content://example.app.provider/artwork?src=one";
    private static final String OTHER_PROVIDER = "content://other.app.provider/artwork/2";
    private final byte[] artwork = new byte[] {1, 2, 3};

    @Test public void providerArtworkIsDeferredWhileLauncherIsInBackground() {
        ProviderArtworkGate gate = new ProviderArtworkGate();
        assertNull(gate.load(PROVIDER, () -> {
            fail("A background launcher must not open another app's provider");
            return null;
        }));
    }

    @Test public void providerArtworkLoadsWhileLauncherIsResumed() {
        ProviderArtworkGate gate = new ProviderArtworkGate();
        gate.setResumed(true);
        assertArrayEquals(artwork, gate.load(PROVIDER, () -> artwork));
    }

    @Test public void nonProviderArtworkIsNeverDeferred() {
        ProviderArtworkGate gate = new ProviderArtworkGate();
        assertArrayEquals(artwork, gate.load("https://images.example/poster.jpg", () -> artwork));
        assertArrayEquals(artwork, gate.load("android.resource://example.app/drawable/poster", () -> artwork));
        assertArrayEquals(artwork, gate.load("file:///data/poster.png", () -> artwork));
    }

    @Test public void deferredResultIsNotCachedAndLoadsAfterResume() throws Exception {
        java.io.File directory = java.nio.file.Files.createTempDirectory("posters").toFile();
        PosterCache cache = new PosterCache(directory, TimeUnit.DAYS.toMillis(30));
        ProviderArtworkGate gate = new ProviderArtworkGate();
        assertNull(cache.get(PROVIDER, () -> gate.load(PROVIDER, () -> artwork)));
        gate.setResumed(true);
        assertArrayEquals(artwork, cache.get(PROVIDER, () -> gate.load(PROVIDER, () -> artwork)));
    }

    @Test public void waitingRequestIsDroppedWhenLauncherIsLeft() throws Exception {
        ProviderArtworkGate gate = new ProviderArtworkGate();
        gate.setResumed(true);
        CountDownLatch firstStarted = new CountDownLatch(1);
        CountDownLatch releaseFirst = new CountDownLatch(1);
        ExecutorService executor = Executors.newFixedThreadPool(2);
        try {
            Future<byte[]> first = executor.submit(() -> gate.load(PROVIDER, () -> {
                firstStarted.countDown();
                await(releaseFirst);
                return artwork;
            }));
            assertTrue(firstStarted.await(5, TimeUnit.SECONDS));
            Future<byte[]> second = executor.submit(() -> gate.load(PROVIDER + "&two", () -> {
                fail("A queued request must not run after the launcher is left");
                return null;
            }));
            Thread.sleep(100);
            gate.setResumed(false);
            releaseFirst.countDown();
            assertArrayEquals(artwork, first.get(5, TimeUnit.SECONDS));
            assertNull(second.get(5, TimeUnit.SECONDS));
        } finally {
            executor.shutdownNow();
        }
    }

    @Test public void requestsToOneProviderRunOneAtATime() throws Exception {
        ProviderArtworkGate gate = new ProviderArtworkGate();
        gate.setResumed(true);
        AtomicInteger active = new AtomicInteger();
        AtomicInteger maxActive = new AtomicInteger();
        ExecutorService executor = Executors.newFixedThreadPool(4);
        try {
            Future<?>[] results = new Future<?>[8];
            for (int i = 0; i < results.length; i++) {
                String uri = PROVIDER + "&n=" + i;
                results[i] = executor.submit(() -> gate.load(uri, () -> {
                    maxActive.accumulateAndGet(active.incrementAndGet(), Math::max);
                    sleep(20);
                    active.decrementAndGet();
                    return artwork;
                }));
            }
            for (Future<?> result : results) result.get(10, TimeUnit.SECONDS);
            assertEquals(1, maxActive.get());
        } finally {
            executor.shutdownNow();
        }
    }

    @Test public void differentProvidersDoNotWaitForEachOther() throws Exception {
        ProviderArtworkGate gate = new ProviderArtworkGate();
        gate.setResumed(true);
        CountDownLatch slowStarted = new CountDownLatch(1);
        CountDownLatch releaseSlow = new CountDownLatch(1);
        ExecutorService executor = Executors.newFixedThreadPool(2);
        try {
            Future<byte[]> slow = executor.submit(() -> gate.load(PROVIDER, () -> {
                slowStarted.countDown();
                await(releaseSlow);
                return artwork;
            }));
            assertTrue(slowStarted.await(5, TimeUnit.SECONDS));
            Future<byte[]> other = executor.submit(() -> gate.load(OTHER_PROVIDER, () -> artwork));
            assertArrayEquals(artwork, other.get(5, TimeUnit.SECONDS));
            releaseSlow.countDown();
            slow.get(5, TimeUnit.SECONDS);
        } finally {
            executor.shutdownNow();
        }
    }

    @Test public void authorityParsing() {
        assertEquals("example.app.provider", ProviderArtworkGate.authority(PROVIDER));
        assertEquals("other.app.provider", ProviderArtworkGate.authority(OTHER_PROVIDER));
        assertEquals("bare.provider", ProviderArtworkGate.authority("content://bare.provider"));
        assertEquals("", ProviderArtworkGate.authority("content://"));
        assertFalse(ProviderArtworkGate.isProviderUri(null));
        assertFalse(ProviderArtworkGate.isProviderUri("https://images.example/a.jpg"));
    }

    private static void await(CountDownLatch latch) {
        try {
            latch.await(5, TimeUnit.SECONDS);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    private static void sleep(long millis) {
        try {
            Thread.sleep(millis);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
