#version 330 core

in vec2 vTexCoord;

uniform float u_Time;

out vec4 color;

void main()
{
    color = vec4(vTexCoord.x, vTexCoord.y, abs(sin(u_Time)), 1.0);
};
