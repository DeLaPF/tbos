#version 330 core

#define PI 3.14159265358979323

in vec2 vTexCoord;

uniform vec2 u_Mouse;
uniform vec2 u_Res;
uniform float u_Time;

float roundTooth(float time)
{
    return (abs(sin(time))-abs(cos(time)))*0.5+0.5;
};

float pointyTooth(float time)
{
    // smp (sample) functions on the domain [-1, 1] (i.e. limit x to [-1, 1])
    float smp = mod(time, 2) - 1;
    float a = cos(smp*(PI/2.0));
    float b = abs(smp*(PI/2.0)) + 1;
    return a/b;
};

vec3 colorA = vec3(0.18, 0.03, 0.01);
vec3 colorB = vec3(0.38, 0.75, 0.8);
void main()
{
    // float pct = roundTooth(u_Time);
    float pct = pointyTooth(u_Time);
    gl_FragColor = vec4(mix(colorA, colorB, pct), 1.0);
};
