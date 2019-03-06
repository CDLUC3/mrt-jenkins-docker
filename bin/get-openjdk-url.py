#!/usr/bin/env python

############################################################
# get-openjdk-url.py
#
# Gets the URL for the latest OpenJDK release from
# https://github.com/AdoptOpenJDK/openjdk-11-binaries
############################################################

import json
import urllib2

RELEASES_URL = 'https://api.github.com/repos/AdoptOpenJDK/openjdk11-binaries/releases'
ARCH_X64_LINUX = "x64_linux"
JVM_HOTSPOT = "hotspot"


def get_releases_json(releases_url=RELEASES_URL):
    opener = urllib2.build_opener()
    opener.addheaders = [
        # Get the release information in JSON format
        ('Accept', 'application/vnd.github+json'),
        # GitHub doesn't like random Python scripts but it's OK with curl
        # If this offends anybody, we could just shell out to curl :P
        ('User-Agent', 'curl/7.54.0')
    ]
    response = opener.open(releases_url)
    return json.load(response)


def find_latest_release(releases_json, arch=ARCH_X64_LINUX, jvm=JVM_HOTSPOT):
    # Make sure we got the JSON we were expecting
    assert isinstance(releases_json, list), 'expected a JSON list, got ' + type(releases_json)
    for release in releases_json:
        if release["prerelease"]:
            # Skip prerelease erleases
            continue
        for asset in release["assets"]:
            # Find the right OS/architecture and JVM type
            asset_name = asset["name"]
            if arch + "_" + jvm in asset_name:
                return asset["browser_download_url"]
    return None


latest_release_url = find_latest_release(get_releases_json())
print(latest_release_url)
