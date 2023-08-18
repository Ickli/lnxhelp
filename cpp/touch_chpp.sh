# DESCRIPTION:
# Touches cpp and hpp files in specified directory.
# If directory is not passed, pwd is used

# ARGUMENTS:
# cpp/hpp name, directory (optional)

if [ -z $2 ]; then
	filepath="$(pwd)"
else
	filepath="$2"
fi

filename=$1
touch "${filepath}/${filename}.hpp"
touch "${filepath}/${filename}.cpp"
