#!/bin/bash

# --- Default Configuration ---
GAPPS=true
REL="bp4a"
TYPE="userdebug"
DEVICE="dodge"
TARGET_BASE=""
WORKING_DIR="/home/pppig/losw"

# --- Functions ---
show_help() {
    echo "Usage: $(basename "$0") [options] [targets]"
    echo ""
    echo "Options:"
    echo "  -d <device>     Set device (default: dodge)"
    echo "  -t <type>       Set build type (userdebug, eng, user) (default: userdebug)"
    echo "  -g <true|false> Enable/Disable GApps (default: true)"
    echo "  -h              Show this help message"
    echo ""
    echo "Targets:"
    echo "  kernel          Builds boot, vendor_boot, dlkm, etc."
    echo "  bacon           Full OTA package (default if targets empty)"
    echo "  [custom]        Any other mka target"
}

# --- Argument Parsing ---
while getopts "d:t:g:h" opt; do
    case "$opt" in
        d) DEVICE="$OPTARG" ;;
        t) TYPE="$OPTARG" ;;
        g) GAPPS="$OPTARG" ;;
        h) show_help; exit 0 ;;
        *) show_help; exit 1 ;;
    esac
done

# Shift off the options so $@ contains only targets
shift $((OPTIND-1))

# --- Environment Setup ---
cd "$WORKING_DIR" || { echo "Failed to enter $WORKING_DIR"; exit 1; }

source build/envsetup.sh

# CCACHE Setup
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
export CCACHE_DIR="${WORKING_DIR}/.cache"
$CCACHE_EXEC -M 100G

# Build Identity & Metadata
export LC_ALL=C
export KBUILD_BUILD_USER="pppig"
export KBUILD_BUILD_HOST="gentoolinux"
export KERNEL_LTO=none
export WITH_GMS=$GAPPS

if [ "$GAPPS" = "true" ]; then
    export TARGET_UNOFFICIAL_BUILD_ID="Pig-Gapps"
else
    export TARGET_UNOFFICIAL_BUILD_ID="Pig"
fi

if [ -f "${WORKING_DIR}/los_buildNumber" ]; then
    export BUILD_NUMBER=$(cat "${WORKING_DIR}/los_buildNumber")
fi

unset LEX

# --- Lunch ---
echo "🍱 Lunching lineage_${DEVICE}-${REL}-${TYPE}..."
lunch "lineage_${DEVICE}-${REL}-${TYPE}" || exit 1

# --- Cleanup ---
echo "🧹 Cleaning up..."
mka installclean
rm -rf "out/target/product/${DEVICE}"

# --- Target Logic ---
# Handle special 'kernel' keyword or custom targets
case "$1" in
    "kernelimages")
        if [ "$DEVICE" = "dodge" ]; then
            FINAL_TARGETS="initbootimage bootimage vendorbootimage vendor_dlkmimage dtboimage"
        else
            FINAL_TARGETS="bootimage vendorbootimage vendor_dlkmimage dtboimage"
        fi
        ;;
    "")
        # Default target if none specified
        FINAL_TARGETS="bacon"
        ;;
    *)
        # Use whatever was passed as arguments
        FINAL_TARGETS="$*"
        ;;
esac

# --- Execution ---
echo "🚀 Building target(s): ${FINAL_TARGETS}"
mka $FINAL_TARGETS -j32 || exit 1

echo "✅ Build Completed Successfully!"
