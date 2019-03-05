#!/usr/bin/env python

import json
import urllib2

RELEASES_URL = 'https://api.github.com/repos/AdoptOpenJDK/openjdk11-binaries/releases'
ARCH_X64_LINUX = "x64_linux"
JVM_HOTSPOT = "hotspot"


def get_releases_json(releases_url=RELEASES_URL):
    opener = urllib2.build_opener()
    opener.addheaders = [
        ('Accept', 'application/vnd.github+json'),
        ('User-Agent', 'curl/7.54.0')  # sketchy, I know
    ]
    response = opener.open(releases_url)
    return json.load(response)


def find_latest_release(releases_json, arch=ARCH_X64_LINUX, jvm=JVM_HOTSPOT):
    assert isinstance(releases_json, list), 'expected a JSON list, got ' + type(releases_json)
    for release in releases_json:
        assert isinstance(release, dict), 'expected a JSON dict, got ' + type(release)
        if release["prerelease"]:
            continue
        for asset in release["assets"]:
            assert isinstance(asset, dict), 'expected a JSON dict, got ' + type(asset)
            asset_name = asset["name"]
            if arch + "_" + jvm in asset_name:
                return asset["browser_download_url"]
    return None


latest_release_url = find_latest_release(get_releases_json())
print(latest_release_url)
