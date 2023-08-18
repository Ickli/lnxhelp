# exists(aliasname)
function exists {
	echo $($1) | grep -o "$2"
}

exists $1 $2
