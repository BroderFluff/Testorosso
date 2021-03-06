cmake_minimum_required(VERSION 3.10)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

project(Testorosso CXX)

include(Tools/CMake/GenVersion.cmake)
include(Tools/CMake/GenConfig.cmake)

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

install(FILES
    "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/TestorossoConfig.cmake"
    "${PROJECT_BINARY_DIR}/TestorossoConfigVersion.cmake"
    DESTINATION "${INSTALL_CMAKE_DIR}" COMPONENT dev)

install(TARGETS Testorosso
    EXPORT TestorossoTargets DESTINATION lib)
install(DIRECTORY Include/Testorosso/ DESTINATION include/Testorosso
    FILES_MATCHING PATTERN "*.h")

install(EXPORT TestorossoTargets DESTINATION "${INSTALL_CMAKE_DIR}" COMPONENT dev)
