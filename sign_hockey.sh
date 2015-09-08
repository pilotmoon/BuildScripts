rm -rf "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/HockeySDK.framework/Headers"
rm -rf "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/HockeySDK.framework/Versions/Current/Headers"
rm -rf "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/HockeySDK.framework/Resources/de.lproj"
rm -rf "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/HockeySDK.framework/Resources/fi.lproj"
rm -rf "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/HockeySDK.framework/Resources/fr.lproj"
rm -rf "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/HockeySDK.framework/Resources/it.lproj"
rm -rf "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/HockeySDK.framework/Resources/ja.lproj"
rm -rf "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/HockeySDK.framework/Resources/nb.lproj"
rm -rf "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/HockeySDK.framework/Resources/sv.lproj"

HOCKEY_BIN="$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/HockeySDK.framework/Versions/A/HockeySDK"
if lipo "$HOCKEY_BIN" -verify_arch i386
	then lipo -remove i386 "$HOCKEY_BIN" -output "$HOCKEY_BIN"
fi

codesign -s "Developer ID Application: Nicholas Moore" -f "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/HockeySDK.framework/Versions/A"