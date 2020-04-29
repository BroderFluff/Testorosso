cmake_minimum_required(VERSION 3.10)

project(Testorosso CXX)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_library(Testorosso STATIC
    Src/Testorosso.cpp
    Include/Testorosso/Testorosso.h)

target_include_directories(Testorosso
    PRIVATE
        Include/Testorosso/
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

set(MAJOR_VERSION 0)
set(MINOR_VERSION 1)

configure_file(Config.h.in Config.h @ONLY)

install(
    TARGETS
        Testorosso
    DESTINATION
        lib
)
