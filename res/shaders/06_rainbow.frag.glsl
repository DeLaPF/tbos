#version 330 core

#define PI 3.14159265358979323

in vec2 vTexCoord;

uniform vec2 u_Mouse;
uniform vec2 u_Res;
uniform float u_Time;

vec3 selInRange(float val, float min, float max)
{
    float offTilMin = step(min, val);
    float offTilMax = step(max, val);
    float sel = offTilMin-offTilMax;

    vec3 black = vec3(0.0);
    vec3 white = vec3(1.0);
    return (1.0-sel)*black + sel*white;
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_Res;

    vec3 r = vec3(1.0, 0.0, 0.0) * selInRange(st.x, 0.0, 0.14);
    vec3 o = vec3(1.0, 0.58, 0.0) * selInRange(st.x, 0.14, 0.29);
    vec3 y = vec3(1.0, 1.0, 0.0) * selInRange(st.x, 0.29, 0.43);
    vec3 g = vec3(0.0, 1.0, 0.0) * selInRange(st.x, 0.43, 0.57);
    vec3 b = vec3(0.0, 0.0, 1.0) * selInRange(st.x, 0.57, 0.72);
    vec3 i = vec3(0.25, 0.0, 1.0) * selInRange(st.x, 0.72, 0.86);
    vec3 v = vec3(0.5, 0.0, 1.0) * selInRange(st.x, 0.86, 1.0);

    gl_FragColor = vec4((r+o+y+g+b+i+v), 1.0);
}
