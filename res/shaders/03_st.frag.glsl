#version 330 core

in vec2 vTexCoord;

uniform vec2 u_Mouse;
uniform vec2 u_Res;
uniform float u_Time;

out vec4 color;

void main()
{
    vec2 st = gl_FragCoord.xy/u_Res;
    color = vec4(st.x, st.y, 0.0, 1.0);
};
