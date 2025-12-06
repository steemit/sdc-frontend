#!/bin/bash

# Script to download GeoIP2 database for blocking China IPs
# Run this script manually before building Docker image
# Note: This script downloads GeoIP2 format (.mmdb) for use with ngx_http_geoip2_module

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GEOIP_DIR="${SCRIPT_DIR}/geoip"
GEOIP_FILE="${GEOIP_DIR}/Country.mmdb"

echo "Downloading Country.mmdb database..."

# Create geoip directory if it doesn't exist
mkdir -p "${GEOIP_DIR}"

# Try multiple sources for GeoIP2 database
echo "Trying source 1: Loyalsoldier geoip (Country.mmdb)..."
if wget -q -O "${GEOIP_FILE}.tmp" "https://github.com/Loyalsoldier/geoip/releases/download/202512040022/Country.mmdb" 2>/dev/null; then
    # Check if file is gzipped
    if file "${GEOIP_FILE}.tmp" | grep -q "gzip"; then
        mv "${GEOIP_FILE}.tmp" "${GEOIP_FILE}.gz"
        gunzip -f "${GEOIP_FILE}.gz"
    else
        mv "${GEOIP_FILE}.tmp" "${GEOIP_FILE}"
    fi
    if [ -f "${GEOIP_FILE}" ] && [ -s "${GEOIP_FILE}" ]; then
        echo "Download successful from Loyalsoldier geoip (Country.mmdb)"
        echo "Country.mmdb database downloaded to: ${GEOIP_FILE}"
        echo "File size: $(du -h "${GEOIP_FILE}" | cut -f1)"
        exit 0
    fi
fi

echo ""
echo "Error: Failed to download GeoIP2 database from all sources"
echo ""
echo "Please try one of the following:"
echo "1. Check your internet connection"
echo "2. Download GeoLite2-Country.mmdb manually from:"
echo "   - https://github.com/Loyalsoldier/geoip/releases"
echo "   - https://github.com/P3TERX/GeoLite.mmdb"
echo "3. Place the file in the geoip/ directory as GeoLite2-Country.mmdb"
exit 1

