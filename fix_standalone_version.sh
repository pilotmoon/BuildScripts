# Subtract a constant from the bundle version
# PlistBuddy and git executables
buddy='/usr/libexec/PlistBuddy'
subtract=$1

# the plist file and key to replace
plist=${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}
key='CFBundleVersion'

ver_num=`expr $CURRENT_PROJECT_VERSION - $subtract`

# do the replacement
echo "Setting $key to $ver_num in Info.plist"
$buddy -c "Set :$key $ver_num" "$plist"
