#include <string>
#include "clang/ASTMatchers/ASTMatchers.h"

#include "Utils.h"

namespace Utils {
    using namespace clang;
    using namespace clang::ast_matchers;
    using clang::tooling::Replacements;

    void AddReplacement(const MatchFinder::MatchResult &Result, std::string &ArgText){
        SourceManager& SrcMgr = Result.Context->getSourceManager();
        const FileEntry* Entry = SrcMgr.getFileEntryForID(SrcMgr.getFileID(Call->getLocStart()));
        llvm::StringRef FileName = Entry->getName();
        Replace->insert(std::pair<std::string, Replacements>(FileName, Replacement(*Result.SourceManager, Call, ArgText)));
    }
}