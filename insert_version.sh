# This script fixes up the CFBundleShortVersionString with a string derived from git.
# Place it as a Build Phase just before Copy Bundle Resources

# clone: git submodule add git@gist.github.com:1151287.git gist-1151287
# call:  ${SRCROOT}/gist-1151287/insert_version.sh

# PlistBuddy and git executables
buddy='/usr/libexec/PlistBuddy'
git='/usr/bin/git'

# the plist file and key to replace
plist=${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}
key='CFBundleShortVersionString'
record_key='NMOriginalBundleShortVersionString'

# version string
version=`$git describe --dirty --tags`

# clean if it has a rc tag
if [[ "$version" =~ ^[0-9\.]+-rc[0-9]+$ ]] ; then
  echo "Is rc version"
  clean="clean"
else
  echo "Not rc version"
fi

# add debug suffix if debug
if [ ${CONFIGURATION} == 'Debug' ]
then
    version="$version-d"
fi

# add the key to record the original build version
echo "Setting $record_key to $version in Info.plist"
$buddy -c "Delete :$record_key" "$plist"
$buddy -c "Add :$record_key string $version" "$plist"

# clean string if indicated
if [[ $clean ]]
then
  # version string for release builds  (strip off everything after dash, e.g. 1.0.2)
  # i do this so that i can test appstore submission on builds tagged e.g. 1.0.2-test1 
  clean_version=`echo $version | sed 's/\-.*//'`
  echo "Cleaning version string from $version to $clean_version"
  version=$clean_version
fi

# do the replacement
echo "Setting $key to $version in Info.plist"
$buddy -c "Set :$key $version" "$plist"
