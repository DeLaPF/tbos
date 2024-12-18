#version 330 core

layout(location = 0) in vec4 pos;
layout(location = 1) in vec2 texCoord;

out vec2 vTexCoord;

void main()
{
    vTexCoord = texCoord;
    gl_Position = pos;
};
