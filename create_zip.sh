# Call as ${SRCROOT}/BuildScripts/create_zip.sh
# version string (e.g. 1.0.2-dev-1-g35d3b126)

# get the version label
git='/usr/bin/git'
version=`$git describe --dirty`
# option opaque identifier supplied and appended to version
opaque=$1

# get the various paths and file names
zipname="$PRODUCT_NAME-$version$opaque.zip"
folder=$BUILT_PRODUCTS_DIR
appname=$FULL_PRODUCT_NAME

# go to folder and remove existing zip if there is one
cd "$folder"
rm -f "$zipname"

# create zip file for distribution (-r recursive; -y preserve symlinks)
echo "Creating $zipname in $folder from $appname"
zip -r -y "$zipname" "$appname"

