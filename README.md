# binaries

#### kernel-module
This script simply imports/updates kernel modules in your own kernel source repos.

Either clone this repo or run the following command in the root of your kernel folder:

`curl -o kernel-modules https://raw.githubusercontent.com/PIPIPIG233666/binaries/master/kernel-modules && chmod +x kernel-modules`

#### build-kernel
This one builds the kernel. The output directory is ~/out.
#### mkbootimg
Submodule containing mkbootimg and unpackbootimg.
#### mkdtboimg
Executable striped from lastet platform release.

#### helper
Several nice functions kanged from android-linux-stable and LineageOS.

#### jadx
Java decompiler from Mr. skylot.

#### addcopyright
Script for adding LineageOS copyright to device tree source files.
This also converts all tabs to spaces.

#### fix_commit_msg
This script rewrites git commit messages in a specified revision range to include a prefix based on the current directory's name. This is useful for providing context in a repository with multiple subprojects.

**Usage:**
```bash
./fix_commit_msg.sh <revision-range>
```

**Example:**
To rewrite the last 6 commits:
```bash
./fix_commit_msg.sh HEAD~6..HEAD
```

The script will prepend `directory-name:` to each commit message in that range. It correctly handles standard and `Revert` commits.

**Warning:** This script uses `git filter-branch`, which rewrites commit history. You will need to force-push any changes.

#### dump.sh
This script automates the process of downloading, decompressing, and extracting Android firmware partitions from a GitHub release.

It is pre-configured to download specific partitions (`system`, `product`, `vendor`, etc.) from a particular release and repository.

**Dependencies:**
- `gh` (GitHub CLI)
- `zstd`
- `erofs-utils` (for `fsck.erofs`)

**Usage:**
Before running, you may need to edit the script to change the `TAG`, `REPO`, and `PARTITIONS` variables to match your needs.

```bash
./dump.sh
```
The script will download `.img.zst` files, decompress them into `.img` files, and extract their contents into the `./extracted` directory.

#### extract_ramdisk.sh
This script extracts the contents of a compressed ramdisk image.

**Prerequisites:**
- You must source the Android `build/envsetup.sh` script before running.
- `lz4` must be installed.

**Usage:**
The script looks for a file ending in `.img-ramdisk` in the current directory, decompresses it, and extracts the `ramdisk.cpio` into a new directory named after the ramdisk file.

```bash
./extract_ramdisk.sh
```

It will also clean up the intermediate `ramdisk.cpio` and original `.img-ramdisk` files.

#### flash
This interactive script flashes first stage boot partitions to a connected device.

**Dependencies:**
- `adb` and `fastboot` must be installed and in your `PATH`.
- It sources a `helper` script which is expected to be in `~/bin`.

**Usage:**
The script will first prompt you for confirmation. If you agree, it will:
1.  Navigate to the `~/out/` directory.
2.  Reboot the device into the bootloader.
3.  Flash partitions if they exist.
4.  Reboot the device.

```bash
./flash
```


