# args: foldername allow1 allow2 allow3 ...
for x in $1/*.lproj; do
	code=`echo "$x" | sed 's/.*\/\(.*\)\.lproj/\1/' | tr '[:upper:]' '[:lower:]' | tr '_' '-'`
	echo "$code"
	allow=0
	for allowed_code in "${@:2}"; do
		if [ "$code" == "$allowed_code" ]; then			
			allow=1
			break;
		fi
	done
	if [ $allow -eq 1 ]; then
		echo "keeping $x"	
	else
		echo "deleting $x"
		rm -rf "$x"
	fi
done
