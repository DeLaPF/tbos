#pragma once

#include <string>

struct ParsedShader {
    std::string Vertex;
    std::string Fragment;
};

ParsedShader parseShader(const std::string& filepath);
unsigned int compileShader(unsigned int type, const std::string& source);
unsigned int createShader(const std::string& vertexShader, const std::string& fragmentShader);
