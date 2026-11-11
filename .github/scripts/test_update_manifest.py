import hashlib
from pathlib import Path
import tempfile
import unittest
from generate_update_manifest import make_manifest, APKS

class ManifestTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.directory = Path(self.temp.name)
        for name in APKS: (self.directory / name).write_bytes(b'apk-fixture')
    def test_hashes_sizes_build_and_notes(self):
        result = make_manifest('2026.10.02+8113', 'v2026.10.02', self.directory, '- Fixes')
        self.assertEqual(result['versionCode'], 8113)
        self.assertEqual(result['changelog'], '- Fixes')
        for asset in result['assets']:
            self.assertEqual(asset['size'], 11)
            self.assertEqual(asset['sha256'], hashlib.sha256(b'apk-fixture').hexdigest())
    def test_tag_must_match_android_version(self):
        with self.assertRaises(ValueError): make_manifest('2026.10.02+8113', 'v-dev', self.directory, '')
        with self.assertRaises(ValueError): make_manifest('2026.10.02+0', 'v2026.10.02', self.directory, '')
    def test_missing_apk_fails_release_metadata(self):
        (self.directory / APKS[1]).unlink()
        with self.assertRaises(ValueError): make_manifest('2026.10.02+8113', 'v2026.10.02', self.directory, '')

if __name__ == '__main__': unittest.main()
