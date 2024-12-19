#include "shader_linker.hpp"

#include <algorithm>
#include <filesystem>
#include <format>
#include <iostream>

#include "shader.hpp"

std::vector<ShaderPair> linkShaders(const char* shaderDir)
{
    std::vector<ShaderPair> pairs;
    std::vector<std::filesystem::path> shaderFiles;
    bool hasDefaultVert = false;
    bool hasDefaultFrag = false;
    std::filesystem::path root(shaderDir);

    for (const auto &entry : std::filesystem::directory_iterator(root)) {
        if (entry.is_regular_file()) {
            auto stem = entry.path().stem().stem().string();
            auto preExt = entry.path().stem().extension().string();
            auto ext = entry.path().extension().string();
            if (preExt == ".vert" || preExt == ".frag" || ext == ".glsl") {
                if (stem == "default") {
                    if (preExt == ".vert") {
                        hasDefaultVert = true;
                    } else if (preExt == ".frag") {
                        hasDefaultFrag = true;
                    }
                } else {
                    shaderFiles.push_back(entry.path());
                }
            }
        }
    }
    std::sort(shaderFiles.begin(), shaderFiles.end());
    
    for (int i = 0; i < shaderFiles.size(); i++) {
        auto curFile = shaderFiles[i];
        auto stem = curFile.stem().stem().string();
        auto preExt = curFile.stem().extension().string();
        auto ext = curFile.extension().string();
        if (preExt == ".vert") {
            if (i < shaderFiles.size()-1 && stem == shaderFiles[i+1].stem().string()) {
                pairs.push_back(ShaderPair{
                    .name=curFile.stem().stem().string(),
                    .vertPath=curFile.string(),
                    .fragPath=shaderFiles[i+1].string(),
                    .isCombined=false,
                });
                i++;
            } else if (hasDefaultFrag) {
                pairs.push_back(ShaderPair{
                    .name=curFile.stem().stem().string(),
                    .vertPath=curFile.string(),
                    .fragPath=(root / "default.frag.glsl").string(),
                    .isCombined=false,
                });
            } else {
                std::cout << std::format(
                    "{}.vert is missing matching {}.frag (or default.frag)",
                    stem, stem
                ) << std::endl;
            }
        } else if (preExt == ".frag") {
            if (hasDefaultVert) {
                pairs.push_back(ShaderPair{
                    .name=curFile.stem().stem().string(),
                    .vertPath=(root / "default.vert.glsl").string(),
                    .fragPath=curFile.string(),
                    .isCombined=false,
                });
            } else {
                std::cout << std::format(
                    "{}.frag is missing matching {}.vert (or default.vert)",
                    stem, stem
                ) << std::endl;
            }
        } else if (ext == ".glsl") {
            pairs.push_back(ShaderPair{
                .name=curFile.stem().string(),
                .vertPath=curFile.string(),
                .isCombined=true,
            });
        }
    }

    return pairs;
}

std::vector<unsigned int> compileShaders(const std::vector<ShaderPair>& shaderPairs)
{
    std::vector<unsigned int> programIds;
    programIds.reserve(shaderPairs.size());

    for (const auto& pair : shaderPairs) {
        ParsedShader shader;
        if (pair.isCombined) {
            shader = parseShader(pair.vertPath);
        } else {
            ParsedShader temp = parseShader(pair.vertPath, ShaderType::VERTEX);
            shader = parseShader(pair.fragPath, ShaderType::FRAGMENT);
            shader.Vertex = temp.Vertex;
        }
        programIds.push_back(createShader(shader.Vertex, shader.Fragment));
    }

    return programIds;
}
