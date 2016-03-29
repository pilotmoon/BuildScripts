# set the CFBundleLocalizations key to our list of languages

buddy='/usr/libexec/PlistBuddy'
plist=$1
langs_key='CFBundleLocalizations'

# clear the existing array
echo "Clearing $langs_key in $plist"
$buddy -c "Delete :$langs_key" "$plist"
$buddy -c "Add :$langs_key array" "$plist"

# add each allowed language to array
for code in "${@:2}"; do
	echo "Adding $code to $langs_key to in $plist"
	$buddy -c "Add :$langs_key: string $code" "$plist"
done
