get_filename_component(MYPROJECT_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
include(CMakeFindDependencyMacro)

find_dependency(Eigen3 3.3 REQUIRED)
find_dependency(OpenMP REQUIRED)

# kiss_matcher_core PUBLIC-links robin::robin and TBB::tbb, so a consumer needs both
# imported targets to exist. Without these two lines find_package(kiss_matcher) reports
#   The following imported targets are referenced, but are missing: robin::robin
# and sets kiss_matcher_FOUND to FALSE. That is quiet enough to matter: spark-fast-lio
# does find_package(kiss_matcher QUIET) and only warns, so the miss surfaces much later
# as global relocalization being compiled out of a binary whose config still says it is
# enabled.
#
# Both are installed into this same prefix one directory over -- robin always (3rdparty/
# robin/robin.cmake fetches and builds it), TBB only when USE_SYSTEM_TBB is OFF. Neither
# is on CMAKE_PREFIX_PATH in its own right, hence the explicit PATHS; the default search
# still runs first, so a system TBB wins when there is one.
find_dependency(robin PATHS "${MYPROJECT_CMAKE_DIR}/../robin")
find_dependency(TBB PATHS "${MYPROJECT_CMAKE_DIR}/../TBB")

# The parameter must adhere to the format: ${PROJECT_NAME}Targets.cmake
include("${MYPROJECT_CMAKE_DIR}/kiss_matcherTargets.cmake")
