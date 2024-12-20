#version 330 core

#define PI 3.14159265358979323

in vec2 vTexCoord;

uniform vec2 u_Mouse;
uniform vec2 u_Res;
uniform float u_Time;

float smoothSelInRange(float val, float min, float max, float sMin, float sMax)
{
    float offTilMin = smoothstep(min-sMin, min, val);
    float offTilMax = smoothstep(max, max+sMax, val);
    return offTilMin-offTilMax;
}

float smoothSelInRange(float val, float min, float max, float sDist)
{
    return smoothSelInRange(val, min, max, sDist, sDist);
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_Res;

    float f = pow(st.x-0.5, 2.0)*(-2.0);
    // vec3 bg = vec3(0.0, 0.55, 1.00) * smoothstep(st.y+0.07, st.y-0.07, f+1.0);
    vec3 bg = vec3(0.0, 0.55, 1.00) * smoothSelInRange(f+1.00, st.y-1.0, st.y-0.07, 0.00, 0.10);
    vec3 r = vec3(1.00, 0.00, 0.00) * smoothSelInRange(f+1.00, st.y, st.y+0.14, 0.03, 0.07);
    vec3 o = vec3(1.00, 0.58, 0.00) * smoothSelInRange(f+0.86, st.y, st.y+0.14, 0.03, 0.07);
    vec3 y = vec3(1.00, 1.00, 0.00) * smoothSelInRange(f+0.72, st.y, st.y+0.14, 0.03, 0.07);
    vec3 g = vec3(0.00, 1.00, 0.00) * smoothSelInRange(f+0.58, st.y, st.y+0.14, 0.03, 0.07);
    vec3 b = vec3(0.00, 0.00, 1.00) * smoothSelInRange(f+0.44, st.y, st.y+0.14, 0.03, 0.07);
    vec3 i = vec3(0.25, 0.00, 1.00) * smoothSelInRange(f+0.30, st.y, st.y+0.14, 0.03, 0.07);
    vec3 v = vec3(0.50, 0.00, 1.00) * smoothSelInRange(f+0.16, st.y, st.y+0.16, 0.03, 0.07);

    gl_FragColor = vec4((bg+r+o+y+g+b+i+v), 1.0);
}
