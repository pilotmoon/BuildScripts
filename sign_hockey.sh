./remove_langs.sh "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/HockeySDK.framework/Resources/" "$@"

HOCKEY_BIN="$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/HockeySDK.framework/Versions/A/HockeySDK"
if lipo "$HOCKEY_BIN" -verify_arch i386
	then lipo -remove i386 "$HOCKEY_BIN" -output "$HOCKEY_BIN"
fi

rm -rf "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/HockeySDK.framework/Headers"
rm -rf "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/HockeySDK.framework/Versions/Current/Headers"

codesign -s "$signing_identity" -f "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/HockeySDK.framework/Versions/A"