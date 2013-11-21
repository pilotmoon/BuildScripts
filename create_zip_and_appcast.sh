# For running in post-build step in scheme.
# Zips app and creates an appcast entry.

buddy='/usr/libexec/PlistBuddy'
plist=${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}

# get the version label
version=`$buddy -c "Print :CFBundleShortVersionString" "$plist"`

# get the various paths and file names
zipname=`echo "$PRODUCT_NAME-$version.zip" | tr -d ' '`
folder=$BUILT_PRODUCTS_DIR
appname=$FULL_PRODUCT_NAME
product_lowercase=`echo $PRODUCT_NAME | tr '[A-Z]' '[a-z]' | tr -d ' '`

# go to folder and remove existing zip if there is one
cd "$folder"
rm -f "$zipname"

# check that the app is signed
codesign -d -vvvv "$appname"
codesign -vvvv "$appname"
if [[ $? -ne 0 ]]; then
    echo "App is not signed."
    exit 1
else 
    echo "App is signed."
fi

# create zip file for distribution (-r recursive; -y preserve symlinks)
echo "Creating $zipname in $folder from $appname"
zip -r -y -q "$zipname" "$appname"

# filesize
filesize=`stat -f %z "$zipname"`
echo "Filesize: $filesize"

# date
pubdate=`date "+%a, %d %h %Y %T %z"`
echo "Date: $pubdate"

# version num
ver_num=`$buddy -c "Print :CFBundleVersion" "$plist"`
echo "Ver: $ver_num"

# system version
systemversion=`$buddy -c "Print :LSMinimumSystemVersion" "$plist"`
echo "Min system version: $systemversion"

# create appcast
appcast="appcast-$version.txt"
rm -f $appcast
echo "Creating $appcast"

release_notes_webfolder="http://softwareupdate.pilotmoon.com/update/$product_lowercase/notes"
downloads_webfolder='http://pilotmoon.com/downloads'

echo "<item>" >> $appcast
echo "  <title>Version $tag</title>" >> $appcast
echo "  <sparkle:minimumSystemVersion>$systemversion</sparkle:minimumSystemVersion>" >> $appcast
echo "  <sparkle:releaseNotesLink>" >> $appcast
echo "    $release_notes_webfolder/$ver_num.html" >> $appcast
echo "  </sparkle:releaseNotesLink>" >> $appcast
echo "  <pubDate>$pubdate</pubDate>" >> $appcast
echo "  <enclosure url=\"$downloads_webfolder/$zipname\"" >> $appcast
echo "    sparkle:version=\"$ver_num\"" >> $appcast
echo "    sparkle:shortVersionString=\"$version\"" >> $appcast
echo "    length=\"$filesize\"" >> $appcast
echo "    type=\"application/octet-stream\" />" >> $appcast
echo "</item>" >> $appcast

open $folder

