# This script fixes up the CFBundleShortVersionString with a string derived from git.
# Place it as a Build Phase just before Copy Bundle Resources

if [[ "$1" ]]; then
	clean=$1
else 
	clean='noclean'
fi

echo "clean setting: $clean"

if [[ "$2" ]]; then
	buildnum_offset=$2
else 
	buildnum_offset='0'
fi

echo "build number offset: $buildnum_offset"

# PlistBuddy and git executables
buddy='/usr/libexec/PlistBuddy'
git='/usr/bin/git'

# the plist files and keys to replace
plist="${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
sym_plist="${BUILT_PRODUCTS_DIR}/${FULL_PRODUCT_NAME}.dSYM/Contents/Info.plist"

# where to put jekyll template
jekyll_releases_dir="/Users/nick/webgit/pilotmoon.com/jekyll/_releases"

key='CFBundleShortVersionString'
num_key='CFBundleVersion'
record_key='NMVersionDescription'
appcast_key="SUFeedURL"

branch=`$git symbolic-ref --short HEAD`
if [[ "$branch" != "master" ]]; then
    echo "Branch is: $branch"
    echo "Not on master branch; not processing version number"
    exit 1
fi

#build number (needs first commit to be tagged 'buildbase')
buildbase_string=`$git describe --match buildbase`
buildnum=`echo "$buildbase_string" | sed 's/buildbase\-//' | sed 's/-g.*//'`
echo "build number from git is $buildnum"
buildnum=`expr $buildnum + $buildnum_offset`
echo "adjusted build number is $buildnum"

# version string
version=`$git describe --dirty`
echo "description from git is $version"

# add the key to record the original git description
echo "Setting $record_key to $version in $plist"
$buddy -c "Add :$record_key string $version" "$plist"

# clean version string for MAS builds (strip off everything after dash, e.g. 1.0.2)
# i do this so that i can test appstore submission on builds tagged e.g. 1.0.2-test1
clean_version=`echo $version | sed 's/\-.*//'`

# insert appcast if not cleaning for MAS
if [[ "$clean" != "clean" ]]; then

    # if version is not actually tagged, insert buildnum in place of what git-describe gives us
    version=`echo "$version" | sed -E "s/^.+-g[0-9a-f]{7}/\Build $buildnum/"`
    echo "modified description is $version"

    # add debug suffix if debug
    if [[ "${CONFIGURATION}" == 'Debug' ]]; then
        echo "it is a debug build, appending -d"
        version="$version-d"
    fi

    # is this beta channel
    if [[ "$clean_version" != "$version" ]]; then
      channel="Beta"
      appcast_suffix="-beta"
    fi

    # make slugs
    product_slug=`echo "${PRODUCT_NAME}" | tr '[:upper:]' '[:lower:]'`
    version_slug=`echo "${version}" | tr ' ' '-' | tr '[:upper:]' '[:lower:]'`
    product_camel=`echo "${PRODUCT_NAME}" | sed 's/ //'`
    product_file="$product_camel-$version_slug.zip"

    # insert appcast feed url
    appcast="https://softwareupdate.pilotmoon.com/update/${product_slug}/appcast${appcast_suffix}.xml"
    echo "Setting $appcast_key to $appcast in $plist"
    $buddy -c "Add :$appcast_key string $appcast" "$plist"

    # make jekyll template for appcast
    metafile="${BUILT_PRODUCTS_DIR}/`date +%F`-$product_camel-$version_slug.md.draft"

    msv=`$buddy -c "Print :LSMinimumSystemVersion" "$plist"`
    echo "min system version: $msv"

    echo "---" > "$metafile"
    echo "layout: appcast" >> "$metafile"
    echo "date: `date +'%F %H:00:00 %z'`" >> "$metafile"
    echo "product: ${PRODUCT_NAME}" >> "$metafile"
    echo "channel: $channel" >> "$metafile"
    echo "version: $buildnum" >> "$metafile"
    echo "filename: $product_file" >> "$metafile"
    echo "short_version_string: $version" >> "$metafile"
    echo "size: " >> "$metafile"
    echo "minimum_system_version: $msv" >> "$metafile"
    echo "published: no" >> "$metafile"
    echo "---\n\nYour notes here.\n" >> "$metafile"

    # copy to jekyll dir
    if [[ "${CONFIGURATION}" == 'Release' ]]; then
        open "${BUILT_PRODUCTS_DIR}"
        cp "$metafile" "$jekyll_releases_dir"
    fi
else
  # MAS release build
  echo "Cleaning version string from $version to $clean_version"
  version=$clean_version
fi

echo "final version is $version"

# do the replacement
echo "Setting $key to $version in $plist"
$buddy -c "Set :$key $version" "$plist"

echo "Setting $key to $version in $sym_plist"
$buddy -c "Set :$key $version" "$sym_plist"

echo "Setting $num_key to $buildnum in $plist"
$buddy -c "Set :$num_key $buildnum" "$plist"

echo "Setting $num_key to $buildnum in $sym_plist"
$buddy -c "Set :$num_key $buildnum" "$sym_plist"

