# DESCRIPTION:
# Adds aliases to conveniently execute scripts and other files.
# Due to some troubles with msys and windows PATH variables I prefer to use
# this script as a more convenient option for global things on MSYS.
# Not recommended to use on native unix.

# WARNINGS:
# adds alias to itself if it is not there

# ARGUMENTS:
# filename (fullpath or not) -options -'complete' option

# OPTIONS:
# -s - subshell is used for launching scripts
# -f - full path to file is passed 
# -c - add file name without extension to complete
# -'complete' option - last option, can be anything. It will just be passed to complete if -c is passed


# GLOBAL VARS:
ADDED_ALIAS_SUFFIX="__abs" # (__added by script), used for avoiding name conflicts with addalias_exec.sh and other scripts
SUBSHELLCHAR_OPTIONAL=". " # either ". " or empty (same or subshell)

# Unsets all symbols in shell applying passed options.
# Useful when you run script as ". script.sh" and don't want to pollute complete with internal functions' names
# custom_unset(options..., symbols)
function custom_unset {
	# setting options for unset
	while [[ ${1} == "-*" ]]; do
		opt="${opt} $1"
		shift
	done

	# unsetting
	while [ $# -gt 0 ]; do
		unset ${opt} $1
		shift
	done
}

# exists(commandname, elemname)
function exists {
	elemnotfound=""

	elemname=$2
	commandname=$1
	elemfoundstring=$(${commandname} | grep -o ${elemname})
	if [[ ${elemfoundstring} = ${elemnotfound} ]]; then
		return 1
	fi
	return 0;
}

# addalias_exec(name, is_full)
function addalias_exec {
	name=$1
	path=$1
	if $2; then
		name=$(basename ${1%.*}) # removes path/to/ and extension
	else
		name=${1%.*}
	fi
	path=$(realpath "${1}")

	alias ${name}${ADDED_ALIAS_SUFFIX}="${SUBSHELLCHAR_OPTIONAL}${path}" # adding alias
}

# addalias_exec_checked(fullpath, is_full)
function addalias_exec_checked {
	filename=$(basename ${1%.*})
	if ! exists "alias" "${filename}${ADDED_ALIAS_SUFFIX}"; then
		addalias_exec $1 $2
	fi

}

# complete_add_checked(complete_element, options)
function complete_add_checked {
	if ! exists "complete" "${1}"; then
		echo "Added ${1} to complete"
		complete ${2} "${1}${ADDED_ALIAS_SUFFIX}"
	fi
}



# ---------------------------------- #
fullpath=false
add_complete=false


# ADD SELF ALIAS
addalias_exec_checked ${BASH_SOURCE} true
complete_add_checked $(basename ${BASH_SOURCE%.*})

while [ $# -gt 0 ]; do
	case "$1" in
		-f) fullpath=true
			;;
		-c) add_complete=true
			;;
		-s) SUBSHELLCHAR_OPTIONAL=""
			;;
		-*) complete_args="${complete_args} $1"
			;;
		*) break
			;;
	esac
	shift
done # at the end of this loop $1 is always filename or filepath

# ADD ALIAS
if ${fullpath}; then
	addalias_exec_checked $1 true
else
	addalias_exec_checked $1 false
fi
# ADD COMPLETE
if ${add_complete}; then
	complete_add_checked $(basename ${1%.*}) ${complete_args}
fi


custom_unset complete_args \
	fullpath \
	add_complete \
	ADDED_ALIAS_SUFFIX \
	SUBSHELLCHAR_OPTIONAL
custom_unset -f \
	exists \
	addalias_exec \
	addalias_exec_checked \
	complete_add_checked \
	custom_unset

# ---------------------------------- #
