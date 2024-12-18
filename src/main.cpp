#include <array>
#include <iostream>
#include <format>

#include "glad/gl.h"
#include "imgui.h"
#include "imgui_impl_sdl2.h"
#include "imgui_impl_opengl3.h"
#include "SDL.h"
#include "SDL_mouse.h"
#include "SDL_video.h"

#include "gl_helpers.hpp"
#include "shader_linker.hpp"

int main(int argc, char **argv) {
    // Initialize SDL
    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        SDL_Log("SDL initialization failed: %s", SDL_GetError());
        return 1;
    }
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_FLAGS, SDL_GL_CONTEXT_DEBUG_FLAG);

    // Create window with OpenGL context
    SDL_Window* window = SDL_CreateWindow(
        "OpenGL with SDL",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        800, 600,
        SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE
    );
    SDL_GLContext glContext = SDL_GL_CreateContext(window);
    if (!glContext) {
        SDL_Log("OpenGL context creation failed: %s", SDL_GetError());
        return 1;
    }
    int version = gladLoadGL((GLADloadfunc) SDL_GL_GetProcAddress);
    std::cout << std::format(
        "GL {}.{}\n", GLAD_VERSION_MAJOR(version), GLAD_VERSION_MINOR(version)
    ) << std::endl;
    glDebugMessageCallback(handleGLError, 0);

    // Setup Dear ImGui
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); (void)io;
    ImGui::StyleColorsDark();
    ImGui_ImplSDL2_InitForOpenGL(window, glContext);
    ImGui_ImplOpenGL3_Init("#version 330");

    struct Vec2 {
        float x, y;
    };
    struct Vertex {
        Vec2 pos;
        Vec2 texCoord;
    };
    std::array<Vertex, 4> verts = {
        Vertex{{-1.0f, -1.0f}, {0.0f, 1.0f}},
        Vertex{{ 1.0f, -1.0f}, {1.0f, 1.0f}},
        Vertex{{ 1.0f,  1.0f}, {1.0f, 0.0f}},
        Vertex{{-1.0f,  1.0f}, {0.0f, 0.0f}},
    };
    const unsigned int numIndices = 6;
    unsigned int indices[6] = {
        0, 1, 2,
        2, 3, 0
    };

    unsigned int vao;
    glGenVertexArrays(1, &vao);
    glBindVertexArray(vao);

    unsigned int vbo;
    glGenBuffers(1, &vbo);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, verts.size()*sizeof(Vertex), &verts[0], GL_STATIC_DRAW);

    unsigned int ibo;
    glGenBuffers(1, &ibo);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, numIndices*sizeof(unsigned int), indices, GL_STATIC_DRAW);

    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const void*)offsetof(Vertex, pos));
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const void*)offsetof(Vertex, texCoord));
    glEnableVertexAttribArray(1);

    std::vector<ShaderPair> pairs = linkShaders("res/shaders");
    std::vector<const char*> names;
    for (const auto& pair : pairs) { names.push_back(&pair.name[0]); }
    std::vector<unsigned int> shaderIds = compileShaders(pairs);
    int shaderInd = 0;

    // Main loop
    bool running = true;
    while (running) {
        // Handle events
        SDL_Event event;
        while (SDL_PollEvent(&event)) {
            // Forward to Imgui
            ImGui_ImplSDL2_ProcessEvent(&event);
            if (event.type == SDL_QUIT
                || (event.type == SDL_WINDOWEVENT
                && event.window.event == SDL_WINDOWEVENT_CLOSE
                && event.window.windowID == SDL_GetWindowID(window))) {
                running = false;
            } else if (event.type == SDL_WINDOWEVENT) {
                if (event.window.event == SDL_WINDOWEVENT_RESIZED) {
                    int w, h;
                    SDL_GetWindowSize(window, &w, &h);
                    glViewport(0, 0, w, h);
                }
            }
        }
        // Start the Dear ImGui frame
        ImGui_ImplOpenGL3_NewFrame();
        ImGui_ImplSDL2_NewFrame();
        ImGui::NewFrame();

        // Shader selector
        ImGui::Begin("Shader Select");
        ImGui::ListBox("S", &shaderInd, &names[0], (int)names.size(), 4);
        ImGui::End();

        // Update loaded shader
        unsigned int shader = shaderIds[shaderInd];
        glUseProgram(shader);
        // If this is slow may want to move to list def with shaderIds
        int uMouse = glGetUniformLocation(shader, "u_Mouse");
        int uRes = glGetUniformLocation(shader, "u_Res");
        int uTime = glGetUniformLocation(shader, "u_Time");

        // Update uniforms
        int mx, my, w, h;
        SDL_GetMouseState(&mx, &my);
        SDL_GetWindowSize(window, &w, &h);
        glUniform2f(uMouse, (float)mx, (float)my);
        glUniform2f(uRes, (float)w, (float)h);
        glUniform1f(uTime, SDL_GetTicks()/1000.0f);

        // Clear main screen
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        // Render quad
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo);
        glBindVertexArray(vao);
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, nullptr);

        ImGui::Render();
        ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());
        // Swap buffers to display the rendered image
        SDL_GL_SwapWindow(window);
    }

    // gl cleanup
    for (int i = 0; i < shaderIds.size(); i++) {
        if (shaderIds[i] != -1) {
            glDeleteProgram(shaderIds[i]);
        }
    }

    // ImGui Cleanup
    ImGui_ImplOpenGL3_Shutdown();
    ImGui_ImplSDL2_Shutdown();
    ImGui::DestroyContext();

    // SDL Cleanup
    SDL_GL_DeleteContext(glContext);
    SDL_DestroyWindow(window);
    SDL_Quit();

    return 0;
}
