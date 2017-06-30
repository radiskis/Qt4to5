#include <string>

#include "llvm/Support/Error.h"
#include "clang/Tooling/Refactoring.h"

#include "Utils.h"

namespace Utils {
    using namespace clang;
    using namespace llvm;
    using clang::tooling::Replacements;
    using clang::tooling::Replacement;
    
    llvm::Error AddReplacement(const FileEntry* Entry, const Replacement &replacement, std::map<std::string, Replacements> *replacementMap){        
        StringRef FileName = Entry->getName();

        if( replacementMap->count(FileName) > 0){
            return replacementMap->find(FileName)->second.add(replacement);
        }
        else {
            replacementMap->insert(std::pair<std::string, Replacements>(FileName, Replacements(replacement));
        }

        return llvm::Error::success();
    }

    
}