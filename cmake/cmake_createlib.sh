# DESCRIPTION:
# Creates directory with passed name
# Creates CmakeLists.txt in the dir
# Writes to CmakeLists.txt following text:
# ---
# add_library(${dirname})
# target_include_directories(${dirname} ./)
# ---
# ARGUMENTS:
# dirname


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
