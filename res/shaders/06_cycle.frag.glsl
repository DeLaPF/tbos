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

    float smp = mod(val, 1); // domain [0, 1]
    // Note: define function with range [0, 1]
    // float y = smp;
    float y = sin(smp*(PI/2.0));
    // float y = sin(smp*PI);
    y = y*len - min;

    return y;
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_Res;

    float zeroToOne = cycle(u_Time*0.5, -0.4, 1.4);
    float min = 0.0 + zeroToOne;
    float max = 0.4 + zeroToOne;
    gl_FragColor = vec4(selInRange(st.x, min, max), 1.0);
}
