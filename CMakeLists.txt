cmake_minimum_required(VERSION 3.1)

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR})

#find_path(LibClang_INCLUDE_DIR clang-c/Index.h)
#find_library(LIBCLANG_LIBRARY NAMES clang)
find_package(Clang REQUIRED)

include_directories(${LLVM_INCLUDE_DIR} ${CLANG_INCLUDE_DIRS})
link_directories(${LLVM_LIB_DIR} ${CLANG_LIBRARY_DIRS})

###
add_definitions(${LLVM_DEFINITIONS})
add_definitions(${Clang_DEFINITIONS})

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unused-result -fno-rtti -std=c++11")

add_executable(qt4to5
  Qt4To5.cpp
  Utils.cpp
)

target_link_libraries(qt4to5
  clangEdit
  clangTooling
  clangBasic
  clangAST
  clangASTMatchers
)
