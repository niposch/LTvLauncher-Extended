package com.leanbitlab.ltvL;

import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import java.io.File;
import java.io.FileOutputStream;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import static org.junit.Assert.*;

public class PosterCacheTest {
    @Rule public TemporaryFolder temporary = new TemporaryFolder();
    private static final long MAX_AGE = TimeUnit.DAYS.toMillis(30);
    private static final String URI = "content://example.provider/artwork?src=episode&tag=one";
    private final byte[] artwork = new byte[] {82, 73, 70, 70, 1, 2, 3};

    private PosterCache cache(File directory) {
        return new PosterCache(directory, MAX_AGE);
    }

    @Test public void providerBytesSurviveCacheRecreationWithoutOpeningProviderAgain() throws Exception {
        File directory = temporary.newFolder();
        assertArrayEquals(artwork, cache(directory).get(URI, () -> artwork));
        assertArrayEquals(artwork, cache(directory).get(URI, () -> {
            fail("A disk cache hit must not reopen the provider");
            return null;
        }));
        assertEquals(1, directory.listFiles().length);
        assertTrue(directory.listFiles()[0].getName().endsWith(".img"));
    }

    @Test public void changedArtworkUriGetsItsOwnEntry() throws Exception {
        PosterCache cache = cache(temporary.newFolder());
        cache.get(URI, () -> artwork);
        byte[] replacement = new byte[] {9, 8, 7};
        assertArrayEquals(replacement, cache.get(URI.replace("tag=one", "tag=two"), () -> replacement));
        assertArrayEquals(artwork, cache.get(URI, () -> null));
    }

    @Test public void retainsExistingHttpCacheFilenameAndBytes() throws Exception {
        File directory = temporary.newFolder();
        // SHA-1 filename produced by the pre-existing HTTP poster cache.
        File existing = new File(directory, "cdb71a48c16d74521cd57ab6f04132e0ad0a3e44.jpg");
        try (FileOutputStream output = new FileOutputStream(existing)) {
            output.write(artwork);
        }
        assertArrayEquals(artwork, cache(directory).get("https://example.test/poster.jpg", () -> {
            fail("Existing HTTP cache entries should be reused");
            return null;
        }));
    }

    @Test public void simultaneousRequestsOnlyLoadTheProviderOnce() throws Exception {
        PosterCache cache = cache(temporary.newFolder());
        ExecutorService workers = Executors.newFixedThreadPool(2);
        AtomicInteger calls = new AtomicInteger();
        CountDownLatch loading = new CountDownLatch(1);
        CountDownLatch secondStarted = new CountDownLatch(1);
        CountDownLatch release = new CountDownLatch(1);
        PosterCache.Loader loader = () -> {
            calls.incrementAndGet();
            loading.countDown();
            try {
                if (!release.await(5, TimeUnit.SECONDS)) throw new AssertionError("Loader not released");
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                throw new AssertionError(e);
            }
            return artwork;
        };
        try {
            Future<byte[]> first = workers.submit(() -> cache.get(URI, loader));
            assertTrue(loading.await(5, TimeUnit.SECONDS));
            Future<byte[]> second = workers.submit(() -> {
                secondStarted.countDown();
                return cache.get(URI, loader);
            });
            assertTrue(secondStarted.await(5, TimeUnit.SECONDS));
            release.countDown();
            assertArrayEquals(artwork, first.get(5, TimeUnit.SECONDS));
            assertArrayEquals(artwork, second.get(5, TimeUnit.SECONDS));
            assertEquals(1, calls.get());
        } finally {
            release.countDown();
            workers.shutdownNow();
        }
    }

    @Test public void missingAndEmptyResultsCanBeRetried() throws Exception {
        File directory = temporary.newFolder();
        PosterCache cache = cache(directory);
        assertNull(cache.get(URI, () -> null));
        assertEquals(0, cache.get(URI, () -> new byte[0]).length);
        assertEquals(0, directory.listFiles().length);
        assertArrayEquals(artwork, cache.get(URI, () -> artwork));
        assertEquals(1, directory.listFiles().length);
    }

    @Test public void truncatedAndExpiredEntriesAreRefetched() throws Exception {
        File directory = temporary.newFolder();
        PosterCache cache = cache(directory);
        cache.get(URI, () -> artwork);
        File entry = directory.listFiles()[0];
        try (FileOutputStream ignored = new FileOutputStream(entry)) { }
        AtomicInteger calls = new AtomicInteger();
        PosterCache.Loader loader = () -> { calls.incrementAndGet(); return artwork; };
        assertArrayEquals(artwork, cache.get(URI, loader));
        assertTrue(entry.setLastModified(946684800000L));
        assertArrayEquals(artwork, cache.get(URI, loader));
        assertEquals(2, calls.get());
        assertEquals(1, directory.listFiles().length);
    }

    @Test public void pruningRemovesOnlyIdleEntries() throws Exception {
        File directory = temporary.newFolder();
        PosterCache cache = cache(directory);
        cache.get(URI, () -> artwork);
        File old = directory.listFiles()[0];
        assertTrue(old.setLastModified(946684800000L));
        cache.get(URI + "-new", () -> artwork);
        cache.prune();
        assertFalse(old.exists());
        assertEquals(1, directory.listFiles().length);
    }

    @Test public void cacheStorageFailureStillReturnsLoadedArtwork() throws Exception {
        PosterCache cache = cache(temporary.newFile());
        assertArrayEquals(artwork, cache.get(URI, () -> artwork));
    }

    @Test public void localFilesAndResourcesContinueToBypassDiskCache() throws Exception {
        File directory = temporary.newFolder();
        PosterCache cache = cache(directory);
        AtomicInteger calls = new AtomicInteger();
        PosterCache.Loader loader = () -> { calls.incrementAndGet(); return artwork; };
        for (String uri : new String[] {"file:///image.jpg", "/image.jpg", "android.resource://app/1", "", null}) {
            assertArrayEquals(artwork, cache.get(uri, loader));
            assertArrayEquals(artwork, cache.get(uri, loader));
        }
        assertEquals(10, calls.get());
        assertEquals(0, directory.listFiles().length);
    }
}
