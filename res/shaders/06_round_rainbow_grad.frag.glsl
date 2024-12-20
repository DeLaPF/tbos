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

    // TODO: maybe enable passing in uniforms
    // 0: hard edges, 0.14: blend one color up, etc.
    float minBlend = 0.28;

    float f = pow(st.x-0.5, 2.0)*(-2.0);
    float selBg = smoothstep(st.y+0.07, st.y-0.07, f+1.0);
    float selR = smoothSelInRange(f+1.00, st.y, st.y+0.14, minBlend, 0.0);
    float selO = smoothSelInRange(f+0.86, st.y, st.y+0.14, minBlend, 0.0);
    float selY = smoothSelInRange(f+0.72, st.y, st.y+0.14, minBlend, 0.0);
    float selG = smoothSelInRange(f+0.58, st.y, st.y+0.14, minBlend, 0.0);
    float selB = smoothSelInRange(f+0.44, st.y, st.y+0.14, minBlend, 0.0);
    float selI = smoothSelInRange(f+0.30, st.y, st.y+0.14, minBlend, 0.0);
    float selV = smoothSelInRange(f+0.16, st.y, st.y+0.16, minBlend, 0.0);

    // Color select
    vec3 bg = vec3(0.0, 0.55, 1.00) * selBg;
    vec3 r = vec3(1.00, 0.00, 0.00) * selR;
    vec3 o = vec3(1.00, 0.58, 0.00) * selO;
    vec3 y = vec3(1.00, 1.00, 0.00) * selY;
    vec3 g = vec3(0.00, 1.00, 0.00) * selG;
    vec3 b = vec3(0.00, 0.00, 1.00) * selB;
    vec3 i = vec3(0.25, 0.00, 1.00) * selI;
    vec3 v = vec3(0.50, 0.00, 1.00) * selV;

    // Color mix bg->v (blend should work differently if opposite)
    vec3 color = bg;
    // Phantom colors (because of repeated mix with black)
    // color = mix(color, r, 0.5);
    // color = mix(color, o, 0.5);
    // color = mix(color, y, 0.5);
    // color = mix(color, g, 0.5);
    // color = mix(color, b, 0.5);
    // color = mix(color, i, 0.5);
    // color = mix(color, v, 0.5);

    color = mix(color, r, selR);
    color = mix(color, o, selO);
    color = mix(color, y, selY);
    color = mix(color, g, selG);
    color = mix(color, b, selB);
    color = mix(color, i, selI);
    color = mix(color, v, selV);

    gl_FragColor = vec4(color, 1.0);
}
