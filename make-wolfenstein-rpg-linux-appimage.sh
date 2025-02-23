#/bin/sh

# This script packages up a Linux appimage for Wolfenstein RPG.
# It will output the app image in the current directory along with some temporaries.
#
# It takes 4 arguments:
# (1) The path to 'appimagetool'.
#     This can be downloaded from: https://github.com/AppImage/AppImageKit/releases
# (2) The path to 'linuxdeploy'.
#     This can be downloaded from: https://github.com/linuxdeploy/linuxdeploy/releases
# (3) The path to the Wolfenstein RPG source code (root folder).
# (4) The path to the compiled binary for Wolfenstein RPG for the target architecture.
#
# Note: 'appimagetool' and 'linuxdeploy' might require various packages to be installed.
# Run them and examine any errors to see what is missing.
# 
# Install
# wget -O appimagetool https://github.com/AppImage/AppImageKit/releases/latest/download/appimagetool-x86_64.AppImage
# wget -O linuxdeploy https://github.com/linuxdeploy/linuxdeploy/releases/latest/download/linuxdeploy-x86_64.AppImage
# 
# Make
# sudo ./make-wolfenstein-rpg-linux-appimage.sh ./appimagetool ./linuxdeploy $(pwd) ./build/src/WolfensteinRPG
# 

# Exit on any error
set -e

# Extract the input arguments
if [ $# -ne 4 ]; then
    echo "Expected args: <'appimagetool' path> <'linuxdeploy' path> <Wolfenstein RPG source root> <Wolfenstein RPG binary path>"
    exit 1
fi

export APP_IMAGE_TOOL_PATH="$1"
export LINUX_DEPLOY_PATH="$2"
export WOLFENSTEIN_RPG_ROOT_PATH="$3"
export WOLFENSTEIN_RPG_BINARY_PATH="$4"

# Various paths
export APP_DIR_PATH="AppDir"
export DESKTOP_FILE="WolfensteinRPG.desktop"
export SRC_ICON_DIR="$WOLFENSTEIN_RPG_ROOT_PATH/assets"
export SRC_MAIN_ICON_FILE_PATH="$SRC_ICON_DIR/app_icon_64.png"
export DST_MAIN_ICON_FILE_PATH="WolfensteinRPG.png"

# Ensure the WolfensteinRPG binary is executable
chmod +x "$WOLFENSTEIN_RPG_BINARY_PATH"

# Cleanup previous output and some temporaries
rm -rf "$APP_DIR_PATH"
rm -rf "$DESKTOP_FILE"
rm -rf "$DST_MAIN_ICON_FILE_PATH"

export BINARY_FILES=`find -type f -name "WolfensteinRPG*.AppImage"`

for f in $BINARY_FILES; do
  rm "$f"
done

# Make the main icon accessible
cp "$SRC_MAIN_ICON_FILE_PATH" "$DST_MAIN_ICON_FILE_PATH"

# Generate the desktop file
echo "[Desktop Entry]" > "$DESKTOP_FILE"
echo "Name=WolfensteinRPG" >> "$DESKTOP_FILE"
echo "Exec=WolfensteinRPG" >> "$DESKTOP_FILE"
echo "Icon=WolfensteinRPG" >> "$DESKTOP_FILE"
echo "Type=Application" >> "$DESKTOP_FILE"
echo "Categories=Game" >> "$DESKTOP_FILE"

# Use the 'linuxdeploy' tool to build the AppDir
"$LINUX_DEPLOY_PATH" \
  --appdir="$APP_DIR_PATH" \
  --executable="$WOLFENSTEIN_RPG_BINARY_PATH" \
  --desktop-file="$DESKTOP_FILE" \
  --icon-filename="WolfensteinRPG" \
  --icon-file="$DST_MAIN_ICON_FILE_PATH" \
  --icon-file="$SRC_ICON_DIR/app_icon_8.png"\
  --icon-file="$SRC_ICON_DIR/app_icon_16.png"\
  --icon-file="$SRC_ICON_DIR/app_icon_20.png"\
  --icon-file="$SRC_ICON_DIR/app_icon_22.png"\
  --icon-file="$SRC_ICON_DIR/app_icon_24.png"\
  --icon-file="$SRC_ICON_DIR/app_icon_28.png"\
  --icon-file="$SRC_ICON_DIR/app_icon_32.png"\
  --icon-file="$SRC_ICON_DIR/app_icon_36.png"\
  --icon-file="$SRC_ICON_DIR/app_icon_42.png"\
  --icon-file="$SRC_ICON_DIR/app_icon_48.png"\
  --icon-file="$SRC_ICON_DIR/app_icon_64.png"\
  --icon-file="$SRC_ICON_DIR/app_icon_72.png"\
  --icon-file="$SRC_ICON_DIR/app_icon_96.png"\
  --icon-file="$SRC_ICON_DIR/app_icon_128.png"\
  --icon-file="$SRC_ICON_DIR/app_icon_160.png"\
  --icon-file="$SRC_ICON_DIR/app_icon_192.png"\
  --icon-file="$SRC_ICON_DIR/app_icon_256.png"\
  --icon-file="$SRC_ICON_DIR/app_icon_384.png"\
  --icon-file="$SRC_ICON_DIR/app_icon_480.png"\
  --icon-file="$SRC_ICON_DIR/app_icon_512.png"

# Generate the appimage from the AppDir, using 'appimagetool'
"$APP_IMAGE_TOOL_PATH" "$APP_DIR_PATH"

# Cleanup some temporaries (leave the AppDir for manual inspection however)
rm -rf "$DESKTOP_FILE"
rm -rf "$DST_MAIN_ICON_FILE_PATH"
