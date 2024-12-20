#version 330 core

#define PI 3.14159265358979323

in vec2 vTexCoord;

uniform vec2 u_Mouse;
uniform vec2 u_Res;
uniform float u_Time;

void main()
{
    vec2 st = gl_FragCoord.xy/u_Res;
    float sel = step(0.5, st.x);
    sel *= step(0.5, st.y);

    vec3 black = vec3(0.0);
    vec3 white = vec3(1.0);
    vec3 color = (1.0-sel)*black + sel*white;

    gl_FragColor = vec4(color, 1.0);
}
