#version 330 core

#define PI 3.14159265358979323

in vec2 vTexCoord;

uniform vec2 u_Mouse;
uniform vec2 u_Res;
uniform float u_Time;

float plot(vec2 st, float pct)
{
    return smoothstep(pct-0.01, pct, st.y) - smoothstep(pct, pct+0.01, st.y);
}

vec3 colorA = vec3(0.18, 0.03, 0.01);
vec3 colorB = vec3(0.38, 0.75, 0.8);
void main()
{
    vec2 st = gl_FragCoord.xy/u_Res;
    vec3 pct = vec3(st.x);

    pct.r = smoothstep(0.0, 1.0, st.x);
    pct.g = sin(st.x * PI);
    pct.b = pow(st.x, 0.5);

    vec3 color = mix(colorA, colorB, pct);
    // color = mix(color, vec3(1.0, 0.0, 0.0), plot(st, pct.r));
    // color = mix(color, vec3(0.0, 1.0, 0.0), plot(st, pct.g));
    // color = mix(color, vec3(0.0, 0.0, 1.0), plot(st, pct.b));

    // gl_FragColor = vec4(color, 1.0);
    gl_FragColor = vec4(pct, 1.0);
};
