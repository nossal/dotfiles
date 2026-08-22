#!/usr/bin/env bash
set -euo pipefail

CURRENT_TERM="${TERM:-xterm-256color}"
echo "==> Configuring terminfo for undercurl support (TERM=$CURRENT_TERM)"

# 1. Visual test for current undercurl support
echo -e "\n\e[4:3mVisual Test: If you see a wavy line under this text, undercurl is already working.\e[0m\n"

# 2. Check if Smulx already exists
if infocmp -l -x "$CURRENT_TERM" 2>/dev/null | grep -q "Smulx"; then
    echo "[✓] Smulx capability already present. No changes needed."
    exit 0
fi

TEMP_FILE="/tmp/${CURRENT_TERM}.ti"

# 3. Generate terminfo source file
echo "[*] Generating terminfo source file..."
infocmp > "$TEMP_FILE"

# 4. Insert Smulx capability after smul
echo "[*] Adding Smulx capability..."
# Using awk for portable line insertion (avoids sed -i macOS/Linux differences)
awk '/smul=\\E\[4m,/ {print; print "Smulx=\\E[4:%p1%dm,"; next} 1' "$TEMP_FILE" > "${TEMP_FILE}.tmp"
mv "${TEMP_FILE}.tmp" "$TEMP_FILE"

# Fallback if exact pattern wasn't found
if ! grep -q "Smulx" "$TEMP_FILE"; then
    echo "[!] Exact 'smul' pattern not found. Appending Smulx as fallback."
    echo "Smulx=\\E[4:%p1%dm," >> "$TEMP_FILE"
fi

# 5. Compile & reload terminfo
echo "[*] Compiling and installing terminfo..."
if tic -x "$TEMP_FILE"; then
    echo -e "\n[✓] Success! Terminfo updated for '$CURRENT_TERM'."
    echo "To apply changes in your current session, run:"
    echo "  export TERM=$CURRENT_TERM"
    echo "  reset"
else
    echo "[✗] Compilation failed. Please check the generated file: $TEMP_FILE"
    exit 1
fi

# Cleanup
rm -f "$TEMP_FILE"
