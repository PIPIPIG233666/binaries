#!/bin/bash

export FILTER_BRANCH_SQUELCH_WARNING=1

# --- Step 1: Check for command-line argument ---
if [ -z "$1" ]; then
    echo "Error: Missing revision range." >&2
    echo "Usage: $0 <revision-range>" >&2
    echo "Example: $0 HEAD~6..HEAD" >&2
    echo "Example: $0 HEAD^" >&2
    exit 1
fi
REVISION_RANGE="$1"

# --- Step 2: Get the current folder name ---
FOLDER_NAME=$(basename "$(pwd)")

echo "Rewriting commits in range '$REVISION_RANGE' with prefix: '${FOLDER_NAME}:'"

# --- Step 3: Define the sed script template ---
# This part is unchanged. We create a template for the sed script.
RAW_SED_SCRIPT=$(cat <<'EOF'
# On the first line of the commit message...
1 {
    # Check if the line is a Revert commit
    /^Revert / {
        # If it already has the correct prefix inside the quotes, do nothing.
        /Revert "__FOLDER_NAME__:/ b end
        # Otherwise, try to replace an existing prefix (e.g., feat:) inside the quotes.
        s/\(Revert \)"[^:]*:/\1"__FOLDER_NAME__:/
        t end
        # If that failed, it means there was no prefix. Add the new prefix.
        s/\(Revert \)"\(.*\)/\1"__FOLDER_NAME__: \2/
        b end
    }

    # If it is not a Revert commit, apply the original logic.
    s/^[^:]*:/__FOLDER_NAME__:/
    t end

    s/^/__FOLDER_NAME__: /
}
:end
EOF
)

# Safely replace the placeholder with the actual folder name.
# This variable now correctly holds just the script text.
FINAL_SED_SCRIPT=$(echo "$RAW_SED_SCRIPT" | sed "s/__FOLDER_NAME__/$FOLDER_NAME/g")

# --- Step 4: Execute the filter-branch command (FIXED) ---
#
# THE FIX IS HERE: We now explicitly call "sed -e" and pass the script
# inside single quotes to prevent shell interpretation issues.
#
git filter-branch -f --msg-filter "sed -e '$FINAL_SED_SCRIPT'" -- "$REVISION_RANGE"

echo "Done. If the changes are correct, you will need to force-push."
