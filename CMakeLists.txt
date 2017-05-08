cmake_minimum_required(VERSION 3.1)


find_path(LibClang_INCLUDE_DIR clang-c/Index.h)
find_library(LIBCLANG_LIBRARY NAMES clang)
find_package(LLVM REQUIRED)
find_package(LLVM REQUIRED CONFIG)

include_directories(${LLVM_INCLUDE_DIR})
link_directories(${LLVM_LIB_DIR})

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

find_package(Clang REQUIRED)
find_package(Clang REQUIRED clangTooling libClang)
include_directories(${CLANG_INCLUDE_DIRS})
###
add_definitions(${LLVM_DEFINITIONS})
add_definitions(${Clang_DEFINITIONS})

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti -std=c++11")

add_executable(qt4to5
  Qt4To5.cpp
)

target_link_libraries(qt4to5
  clangEdit
  clangTooling
  clangBasic
  clangAST
  clangASTMatchers
)
