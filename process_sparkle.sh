# clean finish_installation
nm_finish_app="$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/Sparkle.framework/Resources/finish_installation.app"
$nm_root/remove_langs.sh "$nm_finish_app/Contents/Resources/" $nm_allowed_languages
rm -rf "$nm_finish_app/Contents/Resources/Sparkle.icns"

nm_finish_bin="$nm_finish_app/Contents/MacOS/finish_installation"
lipo -remove i386 "$nm_finish_bin" -output "$nm_finish_bin"

codesign --timestamp=none -o runtime -s "$nm_signing_identity" -f "$nm_finish_app"

$nm_root/process_framework.sh Sparkle
