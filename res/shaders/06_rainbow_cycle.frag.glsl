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

float cycle(float val, float start, float len)
{
    float min = start * -1.0;
    float smp = mod(val, 1);
    float y = smp;
    return y*len - min;
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_Res;

    float s = cycle(u_Time*0.5, 0.0, 1.0);
    vec3 r0 = vec3(1.00, 0.00, 0.0) * selInRange(st.x, s + -1.00, s + -0.86);
    vec3 o0 = vec3(1.00, 0.58, 0.0) * selInRange(st.x, s + -0.86, s + -0.72);
    vec3 y0 = vec3(1.00, 1.00, 0.0) * selInRange(st.x, s + -0.72, s + -0.57);
    vec3 g0 = vec3(0.00, 1.00, 0.0) * selInRange(st.x, s + -0.57, s + -0.43);
    vec3 b0 = vec3(0.00, 0.00, 1.0) * selInRange(st.x, s + -0.43, s + -0.29);
    vec3 i0 = vec3(0.25, 0.00, 1.0) * selInRange(st.x, s + -0.29, s + -0.14);
    vec3 v0 = vec3(0.50, 0.00, 1.0) * selInRange(st.x, s + -0.14, s +  0.00);
    vec3 r1 = vec3(1.00, 0.00, 0.0) * selInRange(st.x, s +  0.00, s +  0.14);
    vec3 o1 = vec3(1.00, 0.58, 0.0) * selInRange(st.x, s +  0.14, s +  0.29);
    vec3 y1 = vec3(1.00, 1.00, 0.0) * selInRange(st.x, s +  0.29, s +  0.43);
    vec3 g1 = vec3(0.00, 1.00, 0.0) * selInRange(st.x, s +  0.43, s +  0.57);
    vec3 b1 = vec3(0.00, 0.00, 1.0) * selInRange(st.x, s +  0.57, s +  0.72);
    vec3 i1 = vec3(0.25, 0.00, 1.0) * selInRange(st.x, s +  0.72, s +  0.86);
    vec3 v1 = vec3(0.50, 0.00, 1.0) * selInRange(st.x, s +  0.86, s +  1.00);

    gl_FragColor = vec4((r0+o0+y0+g0+b0+i0+v0+r1+o1+y1+g1+b1+i1+v1), 1.0);
}
