cmake_minimum_required(VERSION 3.10)

project(Testorosso CXX)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

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

install(TARGETS Testorosso DESTINATION lib)
install(DIRECTORY Include/Testorosso/ DESTINATION include/Testorosso
    FILES_MATCHING PATTERN "*.h")
#install(EXPORT Testorosso DESTINATION Testorosso)
execute_process(
    COMMAND 
        git describe --tags --long 
    OUTPUT_VARIABLE
        BUILD_VERSION
)

message("BUILD_VERSION: ${BUILD_VERSION}")

string(REGEX REPLACE "^v" "" BUILD_VERSION ${BUILD_VERSION})
string(REGEX MATCH "^([0-9]+)" MAJOR_VERSION ${BUILD_VERSION})
string(REGEX REPLACE "${MAJOR_VERSION}\\." "" BUILD_VERSION ${BUILD_VERSION})
string(REGEX MATCH "^([0-9]+)" MINOR_VERSION ${BUILD_VERSION})
string(REGEX REPLACE "${MINOR_VERSION}\\-" "" BUILD_VERSION ${BUILD_VERSION})
string(REGEX MATCH "^([0-9]+)" PATCH ${BUILD_VERSION})


message("MAJOR_VERSION: ${MAJOR_VERSION}")
message("MINOR_VERSION: ${MINOR_VERSION}")
message("PATCH: ${PATCH}")

configure_file(Version.h.in Version.h @ONLY)

install(
    TARGETS
        Testorosso
    DESTINATION
        lib
)
