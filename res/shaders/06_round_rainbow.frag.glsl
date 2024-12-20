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

    float f = pow(st.x-0.5, 2.0)*(-2.0);
    vec3 bg = vec3(0.0, 0.55, 1.00) * step((f+1.0), st.y);
    vec3 r = vec3(1.00, 0.00, 0.00) * selInRange(f+1.00, st.y, st.y+0.14);
    vec3 o = vec3(1.00, 0.58, 0.00) * selInRange(f+0.86, st.y, st.y+0.14);
    vec3 y = vec3(1.00, 1.00, 0.00) * selInRange(f+0.72, st.y, st.y+0.14);
    vec3 g = vec3(0.00, 1.00, 0.00) * selInRange(f+0.58, st.y, st.y+0.14);
    vec3 b = vec3(0.00, 0.00, 1.00) * selInRange(f+0.44, st.y, st.y+0.14);
    vec3 i = vec3(0.25, 0.00, 1.00) * selInRange(f+0.30, st.y, st.y+0.14);
    vec3 v = vec3(0.50, 0.00, 1.00) * selInRange(f+0.16, st.y, st.y+0.16);

    gl_FragColor = vec4((r+o+y+g+b+i+v+bg), 1.0);
}
