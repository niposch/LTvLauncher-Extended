"""Publish Android build numbers and APK hashes alongside GitHub releases."""
import hashlib
import json
import os
from pathlib import Path
import re
from generate_release_notes import get_fastlane_changelog, get_git_changelog

PACKAGE = 'com.niposch.ltvlauncher.extended'
APKS = ('LTv-Extended-universal-release.apk', 'LTv-Extended-armeabi-v7a-release.apk', 'LTv-Extended-arm64-v8a-release.apk')

def make_manifest(version, tag, directory, changelog):
    match = re.fullmatch(r'([0-9]+\.[0-9]+\.[0-9]+(?:-[0-9A-Za-z.-]+)?)\+([0-9]+)', version)
    if not match or tag != 'v' + match[1] or int(match[2]) <= 0:
        raise ValueError('Release tag must match pubspec versionName; versionCode must be positive')
    assets = []
    for name in APKS:
        path = directory / name
        if not path.is_file() or not 0 < path.stat().st_size <= 200 * 1024 * 1024:
            raise ValueError(f'Missing or invalid release APK: {name}')
        with path.open('rb') as stream:
            digest = hashlib.file_digest(stream, 'sha256').hexdigest()
        assets.append({'name': name, 'size': path.stat().st_size, 'sha256': digest})
    return {'schemaVersion': 1, 'packageName': PACKAGE, 'versionName': match[1],
            'versionCode': int(match[2]), 'changelog': changelog, 'assets': assets}

def main():
    spec = Path('pubspec.yaml').read_text(encoding='utf-8')
    version = re.search(r'^version:\s*(\S+)', spec, re.MULTILINE)[1]
    tag = os.environ['TAG_NAME']
    code = version.split('+')[1]
    notes = get_fastlane_changelog(code) or get_git_changelog(tag)
    manifest = make_manifest(version, tag, Path('build/app/outputs/flutter-apk'), notes)
    Path('update.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('Generated update.json with APK sizes, SHA-256 hashes and release notes')

if __name__ == '__main__':
    main()
