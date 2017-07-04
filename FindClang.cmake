# Detect Clang libraries
#
# Defines the following variables:
#  CLANG_FOUND                 - True if Clang was found
#  CLANG_INCLUDE_DIRS          - Where to find Clang includes
#  CLANG_LIBRARY_DIRS          - Where to find Clang libraries
#
#  CLANG_LIBCLANG_LIB          - Libclang C library
#
#  CLANG_CLANGFRONTEND_LIB     - Clang Frontend (C++) Library
#  CLANG_CLANGDRIVER_LIB       - Clang Driver (C++) Library
#  ...
#
#  CLANG_LIBS                  - All the Clang C++ libraries
#
# Uses the same include and library paths detected by FindLLVM.cmake
#
# See http://clang.llvm.org/docs/InternalsManual.html for full list of libraries

#=============================================================================
# Copyright 2014-2015 Kevin Funk <kfunk@kde.org>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.

#=============================================================================
# MOD: July 2, 2017 Michael Reeves remove hard code version list and simplify find logic.

if(DEFINED Clang_FIND_VERSION)
  if(${Clang_FIND_REQUIRED})
      find_package(LLVM ${Clang_FIND_VERSION} REQUIRED)
      find_package(LLVM ${Clang_FIND_VERSION} REQUIRED CONFIG)
  else()
      find_package(LLVM ${Clang_FIND_VERSION} )
      find_package(LLVM {Clang_FIND_VERSION} CONFIG)
  endif()
else()
  if(${Clang_FIND_REQUIRED})
    find_package(LLVM REQUIRED)
    find_package(LLVM REQUIRED CONFIG)
  else()
    find_package(LLVM )
    find_package(LLVM CONFIG)
  endif()
endif()
set(CLANG_FOUND FALSE)

if (LLVM_FOUND AND LLVM_LIBRARY_DIRS)
  #message(STATUS "Found LLVM ${LLVM_VERSION}")
  #message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

  macro(FIND_AND_ADD_CLANG_LIB _libname_)
    #string(TOUPPER ${_libname_} _libname_)
    find_library(CLANG_${_libname_}_LIB NAMES ${_libname_} HINTS "${LLVM_LIBRARY_DIRS}")
    if(CLANG_${_libname_}_LIB)
      set(CLANG_LIBS ${CLANG_LIBS} ${CLANG_${_libname_}_LIB})
    endif()
  endmacro(FIND_AND_ADD_CLANG_LIB)

  #include()
  # note: On Windows there's 'libclang.dll' instead of 'clang.dll' -> search for 'libclang', too
  find_library(CLANG_LIBCLANG_LIB NAMES clang libclang HINTS ${LLVM_LIBRARY_DIRS}) # LibClang: high-level C interface

  FIND_AND_ADD_CLANG_LIB(clangFrontend)
  FIND_AND_ADD_CLANG_LIB(clangDriver)
  FIND_AND_ADD_CLANG_LIB(clangCodeGen)
  FIND_AND_ADD_CLANG_LIB(clangSema)
  FIND_AND_ADD_CLANG_LIB(clangChecker)
  FIND_AND_ADD_CLANG_LIB(clangAnalysis)
  FIND_AND_ADD_CLANG_LIB(clangRewriteFrontend)
  FIND_AND_ADD_CLANG_LIB(clangRewrite)
  FIND_AND_ADD_CLANG_LIB(clangAST)
  FIND_AND_ADD_CLANG_LIB(clangParse)
  FIND_AND_ADD_CLANG_LIB(clangLex)
  FIND_AND_ADD_CLANG_LIB(clangBasic)
  FIND_AND_ADD_CLANG_LIB(clangARCMigrate)
  FIND_AND_ADD_CLANG_LIB(clangEdit)
  FIND_AND_ADD_CLANG_LIB(clangFrontendTool)
  FIND_AND_ADD_CLANG_LIB(clangRewrite)
  FIND_AND_ADD_CLANG_LIB(clangSerialization)
  FIND_AND_ADD_CLANG_LIB(clangTooling)
  FIND_AND_ADD_CLANG_LIB(clangStaticAnalyzerCheckers)
  FIND_AND_ADD_CLANG_LIB(clangStaticAnalyzerCore)
  FIND_AND_ADD_CLANG_LIB(clangStaticAnalyzerFrontend)
  FIND_AND_ADD_CLANG_LIB(clangSema)
  FIND_AND_ADD_CLANG_LIB(clangRewriteCore)
endif()

if(CLANG_LIBS OR CLANG_LIBCLANG_LIB)
  set(CLANG_FOUND TRUE)
else()
  message(STATUS "Could not find any Clang libraries in ${LLVM_LIBRARY_DIRS}")
endif()

if(CLANG_FOUND)
  set(CLANG_LIBRARY_DIRS ${LLVM_LIBRARY_DIRS})
  set(CLANG_INCLUDE_DIRS ${LLVM_INCLUDE_DIRS})

  # check whether llvm-config comes from an install prefix
  execute_process(
    COMMAND ${LLVM_CONFIG_EXECUTABLE} --src-root
    OUTPUT_VARIABLE _llvmSourceRoot
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )

  string(FIND "${LLVM_INCLUDE_DIRS}" "${_llvmSourceRoot}" _llvmIsInstalled)
  if (NOT _llvmIsInstalled)
    message(STATUS "Detected that llvm-config comes from a build-tree, adding more include directories for Clang")
    list(APPEND CLANG_INCLUDE_DIRS
         "${LLVM_INSTALL_PREFIX}/tools/clang/include" # build dir
         "${_llvmSourceRoot}/tools/clang/include"     # source dir
    )
  endif()

  #Sadly the default ClangConfig.cmake is broken on kubuntu and posiablly elsewhere. So we have to do this.
  #Determine cmake search path based on install prefix as indictate by clang executable location.
  find_program(CLANG_EXE_PATH clang)
  get_filename_component(CLANG_EXE_PREFIX "${CLANG_EXE_PATH}" PATH)
  get_filename_component(CLANG_INSTALL_PREFIX "${CLANG_EXE_PREFIX}" PATH)
  
  set(CLANG_DIRS "${CLANG_INSTALL_PREFIX}/share/clang/cmake" "${CLANG_INSTALL_PREFIX}/share/clang-${LLVM_VERSION_MAJOR}.${LLVM_VERSION_MINOR}/cmake")
  set(CLANG_DIRS "${CLANG_DIRS}" "${CLANG_INSTALL_PREFIX}/share/llvm/cmake" "${CLANG_INSTALL_PREFIX}/share/llvm-${LLVM_VERSION_MAJOR}.${LLVM_VERSION_MINOR}/cmake" "${LLVM_DIR}")
  set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CLANG_DIRS}")
  #Can't use ClangConfig due to improper setup on kubuntu.
  set(CLANG_EXPORTED_TARGETS "clangBasic;clangLex;clangParse;clangAST;clangDynamicASTMatchers;clangASTMatchers;clangSema;clangCodeGen;clangAnalysis;clangEdit;clangRewrite;clangARCMigrate;clangDriver;clangSerialization;clangRewriteFrontend;clangFrontend;clangFrontendTool;clangToolingCore;clangTooling;clangIndex;clangStaticAnalyzerCore;clangStaticAnalyzerCheckers;clangStaticAnalyzerFrontend;clangFormat;clang;clang-format;clang-import-test;clangApplyReplacements;clangRename;clangReorderFields;clangTidy;clangTidyPlugin;clangTidyBoostModule;clangTidyCERTModule;clangTidyLLVMModule;clangTidyCppCoreGuidelinesModule;clangTidyGoogleModule;clangTidyMiscModule;clangTidyModernizeModule;clangTidyMPIModule;clangTidyPerformanceModule;clangTidyReadabilityModule;clangTidyUtils;clangChangeNamespace;clangQuery;clangMove;clangIncludeFixer;clangIncludeFixerPlugin;findAllSymbols;libclang")
  #include(ClangConfig.cmake")
  #Don't hard code a specific path for this. Find ClangTargets.cmake dynamicly.
  find_file(CLANG_CONFIG "ClangTargets.cmake" PATHS /usr/lib/llvm-${LLVM_VERSION_MAJOR}.${LLVM_VERSION_MINOR}/lib/cmake/clang /usr/lib/llvm-${LLVM_VERSION_MAJOR}.${LLVM_VERSION_MINOR}/lib/cmake ${CLANG_DIRS})

  include("${CLANG_CONFIG}")

  message(STATUS "Found Clang (LLVM version: ${LLVM_VERSION})")
  message(STATUS "  Include dirs:       ${CLANG_INCLUDE_DIRS}")
  message(STATUS "  Clang libraries:    ${CLANG_LIBS}")
  message(STATUS "  Libclang C library: ${CLANG_LIBCLANG_LIB}")
else()
  if(Clang_FIND_REQUIRED)
    message(FATAL_ERROR "Could NOT find Clang")
  endif()
endif()
