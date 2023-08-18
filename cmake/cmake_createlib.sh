dirname=$1
dirpath=$(realpath ${dirname})
cmakelists="${dirpath}/CMakeLists.txt"

mkdir ${dirpath}
touch ${cmakelists}

cat <<EndOfFiller > ${cmakelists}
add_library(${dirname}

)
target_include_directories(${dirname} ./)
EndOfFiller
