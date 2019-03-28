#!/usr/bin/env python

############################################################
# get-openjdk-url.py
#
# Gets the URL for the latest OpenJDK release from
# - https://github.com/AdoptOpenJDK/openjdk8-binaries/releases
# - https://github.com/AdoptOpenJDK/openjdk11-binaries/releases
# (etc.)
############################################################

import json
import re
import sys
import urllib2

START_PAGE_URL_FMT = 'https://api.github.com/repos/AdoptOpenJDK/openjdk%d-binaries/releases'
ARCH_X64_LINUX = "x64_linux"
JVM_HOTSPOT = "hotspot"

NEXT_PAGE_URL = re.compile('<([^>]+)>; rel="next"')


def next_page_url_from(link_header):
    m = NEXT_PAGE_URL.search(link_header)
    if m is None:
        return None
    if len(m.groups()) < 1:
        return None
    return m.group(1)


def get_release_url(releases_json_url, arch, jvm):
    opener = urllib2.build_opener()
    opener.addheaders = [
        # Get the release information in JSON format
        ('Accept', 'application/vnd.github+json'),
        # GitHub doesn't like random Python scripts but it's OK with curl
        # If this offends anybody, we could just shell out to curl :P
        ('User-Agent', 'curl/7.54.0')
    ]
    response = opener.open(releases_json_url)
    releases_json = json.load(response)
    latest_release = find_latest_release(releases_json, arch, jvm)
    if latest_release is None:
        print >> sys.stderr, "%s %s release not found in %s" % (arch, jvm, releases_json_url)
        next_page_url = next_page_url_from(response.info().getheader('Link'))
        if next_page_url is not None:
            print >> sys.stderr, "continuing to next page %s" % next_page_url
            latest_release = get_release_url(next_page_url, arch, jvm)
    return latest_release


def get_releases_json(java_version):
    releases_json_url = START_PAGE_URL_FMT % java_version
    opener = urllib2.build_opener()
    opener.addheaders = [
        # Get the release information in JSON format
        ('Accept', 'application/vnd.github+json'),
        # GitHub doesn't like random Python scripts but it's OK with curl
        # If this offends anybody, we could just shell out to curl :P
        ('User-Agent', 'curl/7.54.0')
    ]
    response = opener.open(releases_json_url)
    print(response.info().getheader('Link'))
    return json.load(response)


def find_latest_release(releases_json, arch, jvm):
    # Make sure we got the JSON we were expecting
    assert isinstance(releases_json, list), 'expected a JSON list, got ' + type(releases_json)
    for release in releases_json:
        if release["prerelease"]:
            # Skip prerelease releases
            continue
        for asset in release["assets"]:
            asset_name = asset["name"]
            if ('jdk_' not in asset_name) or (not asset_name.endswith('tar.gz')):
                continue
            # Find the right OS/architecture and JVM type
            if arch + "_" + jvm in asset_name:
                return asset["browser_download_url"]
    return None


def main():
    if len(sys.argv) != 2:
        sys.exit("expected 1 argument, got %d" % (len(sys.argv) - 1))
    version_arg = sys.argv[1]
    try:
        start_page_url = START_PAGE_URL_FMT % int(version_arg)
        latest_release_url = get_release_url(start_page_url, ARCH_X64_LINUX, JVM_HOTSPOT)
        print(latest_release_url)
    except urllib2.HTTPError as e:
        sys.exit("HTTPError: %s" % e)
    except ValueError:
        sys.exit("expected numeric Java major version (e.g. 8, 11), got %s" % version_arg)


main()
