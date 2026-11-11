package com.leanbitlab.ltvL;
import org.junit.Test;
import static org.junit.Assert.*;
import java.util.List;

public class UpdatePackagePolicyTest {
    private String check(boolean debug, String pkg, long version, long expected, int minimumSdk,
            List<String> current, List<String> next, List<String> history) {
        return UpdatePackagePolicy.reject("app.extended", debug, 100, pkg, version, expected, minimumSdk, 34, current, next, history);
    }
    private final List<String> signer = List.of("release-key");
    @Test public void acceptsSignedNewerSelfUpdate() {
        assertNull(check(false, "app.extended", 101, 101, 21, signer, signer, signer));
    }
    @Test public void rejectsDebugAndOtherPackages() {
        assertEquals("debug", check(true, "app.extended", 101, 101, 21, signer, signer, signer));
        assertEquals("package", check(false, "other.app", 101, 101, 21, signer, signer, signer));
    }
    @Test public void rejectsDowngradesSameVersionAndManifestMismatch() {
        assertEquals("version", check(false, "app.extended", 99, 99, 21, signer, signer, signer));
        assertEquals("version", check(false, "app.extended", 100, 100, 21, signer, signer, signer));
        assertEquals("version", check(false, "app.extended", 101, 102, 21, signer, signer, signer));
    }
    @Test public void rejectsUnsupportedSdkAndWrongKey() {
        assertEquals("sdk", check(false, "app.extended", 101, 101, 35, signer, signer, signer));
        assertEquals("signature", check(false, "app.extended", 101, 101, 21, signer, List.of("wrong"), List.of("wrong")));
    }
    @Test public void acceptsVerifiedSingleSignerRotation() {
        assertNull(check(false, "app.extended", 101, 101, 21, signer, List.of("new-key"), List.of("release-key", "new-key")));
    }
    @Test public void multipleSignersMustMatchExactly() {
        assertNull(check(false, "app.extended", 101, 101, 21, List.of("a", "b"), List.of("b", "a"), List.of("a", "b")));
        assertEquals("signature", check(false, "app.extended", 101, 101, 21, List.of("a", "b"), List.of("a"), List.of("a", "b")));
    }
    @Test public void rejectsUnsignedApks() {
        assertEquals("signature", check(false, "app.extended", 101, 101, 21, signer, List.of(), List.of()));
    }
}
