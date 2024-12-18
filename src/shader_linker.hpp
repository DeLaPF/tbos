#pragma once

#include <string>
#include <vector>

// TODO:
// take in relative path to `shaderDir`
// collect all files in `shaderDir`
// pair `.vert` and `.frag` shader files with the same file name
// for files with both vert and frag shaders, it should use `.shader` extension
// for `.vert`/`.frag` files without a pair,
// a `default.vert`/`default.frag` will be used to fill in for the missing file
// if a file has no pair and no default is defined,
// the error will be logged and that shader will not be included
// if no shader programs can be compiled, the program will exit

struct ShaderPair {
    std::string name;
    std::string vertPath;
    std::string fragPath;
    bool isCombined;
};

std::vector<ShaderPair> linkShaders(const char* shaderDir);
std::vector<unsigned int> compileShaders(const std::vector<ShaderPair>& shaderPairs);
