#version 330 core

in vec2 vTexCoord;

uniform vec2 u_Mouse;
uniform vec2 u_Res;
uniform float u_Time;

out vec4 color;

void main()
{
    vec2 pixelPos = vec2(vTexCoord.x*u_Res.x, vTexCoord.y*u_Res.y);
    float ptmDist = distance(pixelPos, u_Mouse);
    color = vec4(abs(sin(ptmDist*0.05)), 0.0, abs(sin(u_Time)), 1.0);
};
