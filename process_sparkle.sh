# clean finish_installation
$nm_root/remove_langs.sh "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/Sparkle.framework/Resources/finish_installation.app/Contents/Resources/" $nm_allowed_languages
rm -rf "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/Sparkle.framework/Resources/finish_installation.app/Contents/Resources/Sparkle.icns"
codesign -o runtime -s "$nm_signing_identity" -f "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/Sparkle.framework/Resources/finish_installation.app"

$nm_root/process_framework.sh Sparkle
