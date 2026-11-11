package com.leanbitlab.ltvL;

import java.util.List;
import java.util.HashSet;

/** Pure archive policy, kept separate for regression tests. */
final class UpdatePackagePolicy {
    static String reject(String installedPackage, boolean debug, long installedVersion,
            String archivePackage, long archiveVersion, long expectedVersion,
            int minimumSdk, int deviceSdk, List<String> installedSigners,
            List<String> archiveSigners, List<String> archiveHistory) {
        if (debug) return "debug";
        if (!installedPackage.equals(archivePackage)) return "package";
        if (archiveVersion != expectedVersion || archiveVersion <= installedVersion) return "version";
        if (minimumSdk > deviceSdk) return "sdk";
        if (installedSigners.isEmpty() || archiveSigners.isEmpty()) return "signature";
        // Multiple signers must match exactly. A single signer may rotate with
        // Android's verified proof-of-rotation chain in the archive SigningInfo.
        if (installedSigners.size() > 1 || archiveSigners.size() > 1) {
            return new HashSet<>(installedSigners).equals(new HashSet<>(archiveSigners)) ? null : "signature";
        }
        return archiveHistory.contains(installedSigners.get(0)) ? null : "signature";
    }
}
