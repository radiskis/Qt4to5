#include <string>

#include "clang/ASTMatchers/ASTMatchers.h"

namespace Utils {
    using namespace clang;
    using namespace clang::ast_matchers;
    void AddReplacement(const MatchFinder::MatchResult &Result, std::string &ArgText);
}