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

