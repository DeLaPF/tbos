#shader vertex
#version 330 core

layout(location = 0) in vec4 pos;
layout(location = 1) in vec2 texCoord;

out vec2 vTexCoord;

void main()
{
    vTexCoord = texCoord;
    gl_Position = pos;
};

#shader fragment
#version 330 core

in vec2 vTexCoord;

out vec4 color;

void main()
{
    color = vec4(vTexCoord.x, vTexCoord.y, 0.0, 1.0);
};
