#!/bin/bash 
nm_framework_name=$1
nm_framework_bin="$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/$nm_framework_name.framework/Versions/A/$nm_framework_name"

# strip resource folders
$nm_root/remove_langs.sh "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/$nm_framework_name.framework/Resources/" $nm_allowed_languages

# remove headers
rm -rf "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/$nm_framework_name.framework/Headers"
rm -rf "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/$nm_framework_name.framework/Versions/Current/Headers"

# lipo binary if needed
if lipo "$nm_framework_bin" -verify_arch i386
	then lipo -remove i386 "$nm_framework_bin" -output "$nm_framework_bin"
fi
