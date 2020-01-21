#include <string>

#include "clang/Tooling/Refactoring.h"

namespace Utils {
    using namespace clang;
    using clang::tooling::Replacements;
    using clang::tooling::Replacement;
    
    llvm::Error AddReplacement(const FileEntry* Entry, const Replacement &replacement, std::map<std::string, Replacements> *replacementMap);
}