package com.leanbitlab.ltvL;

import org.junit.Test;
import java.util.Set;
import static org.junit.Assert.*;

public class WakeHomePolicyTest {
    private final Set<String> homes = Set.of("stock/HomeActivity");
    private WakeHomePolicy home() {
        WakeHomePolicy policy = new WakeHomePolicy();
        policy.windowChanged("stock", "HomeActivity");
        return policy;
    }

    @Test public void doesNotRedirectWithoutWake() {
        assertFalse(home().shouldReturnHome(1, true, "stock", homes));
    }
    @Test public void returnsFromStockHomeAfterWake() {
        WakeHomePolicy policy = home();
        policy.screenOn(100);
        assertTrue(policy.shouldReturnHome(600, true, "stock", homes));
    }
    @Test public void neverInterruptsPlaybackOrSettings() {
        WakeHomePolicy policy = home();
        policy.screenOn(100);
        assertFalse(policy.shouldReturnHome(600, true, "video", homes));
        policy.windowChanged("video", "Player");
        assertFalse(policy.shouldReturnHome(600, true, "video", homes));
        policy.windowChanged("stock", "SettingsActivity");
        assertFalse(policy.shouldReturnHome(600, true, "stock", homes));
    }
    @Test public void doesNotUseStaleWindowMetadata() {
        WakeHomePolicy policy = home();
        policy.screenOn(100);
        assertFalse(policy.shouldReturnHome(600, true, null, homes));
        assertFalse(policy.shouldReturnHome(600, true, "systemui", homes));
    }
    @Test public void frameworkWindowEventsKeepTheActivityIdentity() {
        WakeHomePolicy policy = home();
        policy.screenOn(100);
        policy.windowChanged("stock", "android.widget.FrameLayout");
        assertTrue(policy.shouldReturnHome(600, true, "stock", homes));
        policy.windowChanged("stock", "SettingsActivity");
        policy.windowChanged("stock", "android.widget.FrameLayout");
        assertFalse(policy.shouldReturnHome(600, true, "stock", homes));
        policy.windowChanged("video", "android.widget.FrameLayout");
        assertFalse(policy.shouldReturnHome(600, true, "video", homes));
    }
    @Test public void boundedAndOneShot() {
        WakeHomePolicy policy = home();
        policy.screenOn(100);
        assertFalse(policy.shouldReturnHome(10_100, true, "stock", homes));
        policy.screenOn(20_000);
        assertTrue(policy.shouldReturnHome(20_500, true, "stock", homes));
        policy.completed();
        assertFalse(policy.shouldReturnHome(20_600, true, "stock", homes));
    }
    @Test public void screenOffCancelsAndSleepingCannotRedirect() {
        WakeHomePolicy policy = home();
        policy.screenOn(100);
        assertFalse(policy.shouldReturnHome(600, false, "stock", homes));
        policy.screenOff();
        assertFalse(policy.shouldReturnHome(600, true, "stock", homes));
    }
}
