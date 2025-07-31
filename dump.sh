#!/bin/bash

# 🔧 Configuration
TAG="CPH2417_15.0.0.1001(EX01)"
REPO="PIPIPIG233666/oplus_archive"
PARTITIONS="system system_ext my_product my_manifest product vendor odm my_bigball"
OUTPUT_DIR="./extracted"

mkdir -p "$OUTPUT_DIR"

# 🔁 Loop through partitions
for p in $PARTITIONS; do
    ZST="$p.img.zst"
    IMG="$p.img"
    OUT="$OUTPUT_DIR/$p"

    # ✅ Check if file already exists
    if [[ -f "$ZST" ]]; then
        if [[ "$EXPECTED" == "$ACTUAL" ]]; then
            echo "✅ $ZST exists and checksum matches, skipping download."
        else
            echo "⚠️ Checksum mismatch for $ZST. Re-downloading..."
            gh release download "$TAG" -R "$REPO" -p "$ZST" --clobber
        fi
    elif [[ ! -f "$ZST" ]]; then
        echo "📥 Downloading $ZST..."
        gh release download "$TAG" -R "$REPO" -p "$ZST" --clobber
    fi

    echo "🧩 Decompressing $ZST..."
    zstd -f -d "$ZST" -o "$IMG"

    echo "📂 Extracting $IMG to $OUT..."
    mkdir -p "$OUT"
    fsck.erofs --extract="$OUT" "$IMG" || echo "⚠️ Extraction failed for $p"

    echo "✅ Finished processing $p"
    echo ""
done

echo "🎉 All partitions processed!"
