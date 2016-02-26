./remove_langs.sh "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/ShortcutRecorder.framework/Resources/" "$@"

SHORTCUTRECORDER_BIN="$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/ShortcutRecorder.framework/Versions/A/ShortcutRecorder"
if lipo "$SHORTCUTRECORDER_BIN" -verify_arch i386
	then lipo -remove i386 "$SHORTCUTRECORDER_BIN" -output "$SHORTCUTRECORDER_BIN"
fi

rm -rf "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/ShortcutRecorder.framework/Headers"
rm -rf "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/ShortcutRecorder.framework/Versions/Current/Headers"

codesign -s "$signing_identity" -f "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/ShortcutRecorder.framework/Versions/A"