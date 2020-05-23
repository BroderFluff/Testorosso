cmake_minimum_required(VERSION 3.10)

set(INSTALL_LIB_DIR     lib
    CACHE PATH "Installation directory for libraries")
set(INSTALL_INCLUDE_DIR include
    CACHE PATH "Installation directory for header files")
if(WIN32 AND NOT CYGWIN)
    set(DEF_INSTALL_CMAKE_DIR CMake)
else()
    set(DEF_INSTALL_CMAKE_DIR lib/cmake/${CMAKE_PROJECT_NAME})
endif()
set(INSTALL_CMAKE_DIR ${DEF_INSTALL_CMAKE_DIR}
    CACHE PATH "Installation directory for CMake files")

# Make paths absolute
foreach(p LIB INCLUDE CMAKE)
    set(var INSTALL_${p}_DIR)
    if(NOT IS_ABSOLUTE "${${var}}")
        set(${var} "${CMAKE_INSTALL_PREFIX}/${${var}}")
    endif()
endforeach()

# Create the TestorossoConfig.cmake and TestorossoConfigVersion file
file(RELATIVE_PATH REL_INCLUDE_DIR "${INSTALL_CMAKE_DIR}" "${INSTALL_INCLUDE_DIR}")
# ... for the build tree
set(CONF_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}" "${PROJECT_BINARY_DIR}")
configure_file(TestorossoConfig.cmake.in
    "${PROJECT_BINARY_DIR}/${CMAKE_PEOJCT_NAME}Config.cmake" @ONLY)
# ... for the install tree
set(CONF_INCLUDE_DIRS "${INSTALL_CMAKE_DIR}/${REL_INCLUDE_DIR}")
configure_file(TestorossoConfig.cmake.in
    "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${CMAKE_PROJECT_NAME}Config.cmake" @ONLY)
# ... for both
configure_file(TestorossoConfigVersion.cmake.in "${PROJECT_BINARY_DIR}/${CMAKE_PROJECT_NAME}ConfigVersion.cmake" @ONLY)
