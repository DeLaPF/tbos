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

float cloudySunSel(vec2 st)
{
    float y = pow(st.x-0.8, 2.0)*(2.0) + 0.9;
    return smoothSelInRange(y, st.y-0.1, st.y+0.5, 0.0, 0.1);
}
vec3 cloudySunColor(vec2 st)
{
    vec3 colorA = vec3(0.58, 0.18, 0.086);
    vec3 colorB = vec3(0.949, 0.643, 0.247);
    float y = st.y;
    return mix(colorA, colorB, y);
}

float cSReflSel(vec2 st)
{
    float y = pow(st.x-0.8, 2.0)*(-2.0) + 0.2;
    return smoothSelInRange(y, st.y-0.1, st.y+0.5, 0.1, 0.0);
}

float skySel(vec2 st)
{
    return smoothstep(0.30, 0.40, st.y);
    // return 1.0;
}
vec3 skyColor(vec2 st)
{
    vec3 colorA = vec3(0.145, 0.349, 0.91);
    // vec3 colorB = vec3(0.067, 0.184, 0.502);
    vec3 colorB = vec3(0.075, 0.035, 0.388);
    // vec3 colorB = vec3(0.0, 0.0, 0.0);
    // vec3 colorB = vec3(1.0, 0.0, 0.0);
    float x = st.y*(1.0/0.7);
    float y = pow(x, 0.5);
    return mix(colorA, colorB, y);
    // return mix(colorA, vec3(0.0, 0.0, 0.0), pow(1.0-st.y, 0.5));
}

float skyReflSel(vec2 st)
{
    return 1.0-smoothstep(0.30, 0.40, st.y);
}
vec3 skyReflColor(vec2 st)
{
    vec3 colorB = vec3(0.075, 0.035, 0.388);
    vec3 colorA = vec3(0.145, 0.349, 0.91);
    float x = (st.y)*(1.0/0.3);
    float y = pow(x, 0.5);
    return mix(colorA, colorB, y);
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_Res;

    vec3 sky = skyColor(st) * skySel(st);
    vec3 skyRefl = skyReflColor(st) * skyReflSel(st);
    vec3 cloudySun = cloudySunColor(st) * cloudySunSel(st);
    vec3 cSRefl = cloudySunColor(st) * cSReflSel(st);

    // mix last with selectors => on top
    vec3 color = sky;
    color = mix(color, skyRefl, skyReflSel(st));
    color = mix(color, cloudySun, cloudySunSel(st));
    color = mix(color, cSRefl, cSReflSel(st));

    gl_FragColor = vec4(color, 1.0);
}
