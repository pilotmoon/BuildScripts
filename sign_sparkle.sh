# clean finish_installation
./remove_langs.sh "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/Sparkle.framework/Resources/finish_installation.app/Contents/Resources/" "$@"
rm -rf "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/Sparkle.framework/Resources/finish_installation.app/Contents/Resources/Sparkle.icns"
codesign -s "Developer ID Application: Nicholas Moore" -f "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/Sparkle.framework/Resources/finish_installation.app"

# clean sparkle
rm -rf "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/Sparkle.framework/Headers"
rm -rf "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/Sparkle.framework/Versions/Current/Headers"
./remove_langs.sh "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/Sparkle.framework/Resources/" "$@"
codesign -s "Developer ID Application: Nicholas Moore" -f "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/Sparkle.framework/Versions/A"