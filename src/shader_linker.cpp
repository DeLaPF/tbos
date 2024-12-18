#include "shader_linker.hpp"

#include <algorithm>
#include <filesystem>

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
            auto stem = entry.path().stem().string();
            auto ext = entry.path().extension().string();
            if (ext == ".vert" || ext == ".frag" || ext == ".shader") {
                if (stem == "default") {
                    if (ext == ".vert") {
                        hasDefaultVert = true;
                    } else if (ext == ".frag") {
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
        auto stem = curFile.stem().string();
        auto ext = curFile.extension().string();
        if (ext == ".shader") {
            pairs.push_back(ShaderPair{
                .name=curFile.stem().string(),
                .vertPath=curFile.string(),
                .isCombined=true,
            });
        } else if (ext == ".vert") {
            if (i < shaderFiles.size()-1 && stem == shaderFiles[i+1].stem().string()) {
                pairs.push_back(ShaderPair{
                    .name=curFile.stem().string(),
                    .vertPath=curFile.string(),
                    .fragPath=shaderFiles[i+1].string(),
                    .isCombined=true,
                });
                i++;
            } else if (hasDefaultFrag) {
                pairs.push_back(ShaderPair{
                    .name=curFile.stem().string(),
                    .vertPath=curFile.string(),
                    .fragPath=(root / "default.frag").string(),
                    .isCombined=true,
                });
            }
        } else if (ext == ".frag" && hasDefaultVert) {
            pairs.push_back(ShaderPair{
                .name=curFile.stem().string(),
                .vertPath=(root / "default.vert").string(),
                .fragPath=curFile.string(),
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
        }
        programIds.push_back(createShader(shader.Vertex, shader.Fragment));
    }

    return programIds;
}
