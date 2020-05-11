cmake_minimum_required(VERSION 3.10)

project(Testorosso CXX)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include(Tools/CMake/GenVersion.cmake)

set(INSTALL_LIB_DIR lib CACHE PATH "Installation directory for libraries")
set(INSTALL_INCLUDE_DIR include CACHE PATH "Installation directory for header files")
if(WIN32 AND NOT CYGWIN)
    set(DEF_INSTALL_CMAKE_DIR CMake)
else()
    set(DEF_INSTALL_CMAKE_DIR lib/CMake/Testorosso)
endif()
set(INSTALL_CMAKE_DIR ${DEF_INSTALL_CMAKE_DIR} CACHE PATH "Installation directory for CMake files")

foreach(p LIB INCLUDE CMAKE)
    set(var INSTALL_${p}_DIR)
    if(NOT IS_ABSOLUTE "${${var}}")
        set(${var} "${CMAKE_INSTALL_PREFIX}/${${var}}")
    endif()
endforeach()

#add_executable(Testorosso Src/Testorosso.cpp)
add_library(Testorosso
    STATIC
        Src/Testorosso.cpp
        Include/Testorosso/Testorosso.h)

target_include_directories(Testorosso
    PRIVATE
        Include/Testorosso/
        ${CMAKE_CURRENT_BINARY_DIR}
)

target_compile_options(Testorosso
    PRIVATE
        -Wall
        -pedantic
        -march=skylake
        -mtune=skylake
        $<$<CONFIG:Debug>:
            -fsanitize=address
            -fno-omit-frame-pointer
            -O1
            -g  
        >
        $<$<CONFIG:Release>:
            -Ofast
            -flto
        >
)

target_link_options(Testorosso
    PRIVATE
        $<$<CONFIG:Debug>:
            -fsanitize=address
            -O1
            -g
        >
        $<$<CONFIG:Release>:
            -flto
        >
)

export(TARGETS Testorosso FILE "${PROJECT_BINARY_DIR}/TestorossoTargets.cmake")
export(PACKAGE Testorosso)

# Create the TestorossoConfig.cmake file
file(RELATIVE_PATH REL_INCLUDE_DIR "${INSTALL_CMAKE_DIR}" "${INSTALL_INCLUDE_DIR}")
# ... for the build tree
set(CONF_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}" "${PROJECT_BINARY_DIR}")
configure_file(TestorossoConfig.cmake.in "${PROJECT_BINARY_DIR}/TestorossoConfig.cmake" @ONLY)
# ... for the install tree
set(CONF_INCLUDE_DIRS "\${TESTOROSSO_CMAKE_DIR}/${REL_INCLUDE_DIR}")
configure_file(TestorossoConfig.cmake.in
    "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/TestorossoConfig.cmake" @ONLY)
# ... for both
configure_file(TestorossoConfigVersion.cmake.in "${PROJECT_BINARY_DIR}/TestorossoConfigVersion.cmake" @ONLY)

install(FILES
    "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/TestorossoConfig.cmake"
    "${PROJECT_BINARY_DIR}/TestorossoConfigVersion.cmake"
    DESTINATION "${INSTALL_CMAKE_DIR}" COMPONENT dev)

install(TARGETS Testorosso
    EXPORT TestorossoTargets DESTINATION lib)
install(DIRECTORY Include/Testorosso/ DESTINATION include/Testorosso
    FILES_MATCHING PATTERN "*.h")

install(EXPORT TestorossoTargets DESTINATION "${INSTALL_CMAKE_DIR}" COMPONENT dev)
