package com.leanbitlab.ltvL;

/** A bounded, one-shot opportunity to replace a home screen after standby. */
final class WakeHomePolicy {
    static final long WAKE_WINDOW_MS = 10_000;
    private long deadline;
    private String foregroundPackage;
    private String foregroundClass;

    void screenOn(long now) { deadline = now + WAKE_WINDOW_MS; }
    void screenOff() { deadline = 0; }
    void completed() { deadline = 0; }
    boolean isPending(long now) { return deadline != 0 && now < deadline; }

    void windowChanged(String packageName, String className) {
        // Android often sends a FrameLayout event immediately after the activity
        // event. Keep that activity identity, but never carry it across packages.
        if (packageName.equals(foregroundPackage)
                && (className.startsWith("android.widget.") || className.startsWith("android.view."))) return;
        foregroundPackage = packageName;
        foregroundClass = className;
    }

    boolean shouldReturnHome(long now, boolean interactive, String activePackage,
            java.util.Set<String> homeActivities) {
        return interactive && deadline != 0 && now < deadline
                && activePackage != null && activePackage.equals(foregroundPackage)
                && homeActivities.contains(foregroundPackage + "/" + foregroundClass);
    }
}
