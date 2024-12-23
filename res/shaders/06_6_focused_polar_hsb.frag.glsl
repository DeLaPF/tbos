#version 330 core

#define PI 3.14159265358979323

in vec2 vTexCoord;

uniform vec2 u_Mouse;
uniform vec2 u_Res;
uniform float u_Time;

float querp(float x, vec2 a, vec2 b, vec2 c, vec2 d)
{
    float s0 = (b.y-a.y)/(b.x-a.x);
    float s1 = (c.y-b.y)/(c.x-b.x);
    float s2 = (d.y-c.y)/(d.x-c.x);

    float fx = (x*s0) + (a.y) - (a.x*s0);
    float fbx = (b.x*s0) + (a.y) - (a.x*s0);
    float gx = (x*s1) + (fbx) - (b.x*s1);
    float gcx = (c.x*s1) + (fbx) - (b.x*s1);
    float hx = (x*s2) + (gcx) - (c.x*s2);

    float selNone = 1.0-step(a.x, x) + step(d.x, x);
    float selF = max(1.0-step(b.x, x) - selNone, 0.0);
    float selG = max(1.0-step(c.x, x) - selF - selNone, 0.0);
    float selH = max(1.0-step(d.x, x) - selG - selF - selNone, 0.0);

    return (fx*selF) + (gx*selG) + (hx*selH);
}

float querpP(float x, vec2 b, vec2 c)
{
    return querp(x, vec2(0.0), b, c, vec2(PI*2.0, 1.0));
}

vec3 hsb2rgb(vec3 c)
{
    vec3 rgb = clamp(
        abs(mod((c.x*6.0) + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0,
        0.0,
        1.0
    );
    rgb = rgb*rgb*(3.0 - 2.0*rgb);
    return c.z * mix(vec3(1.0), rgb, c.y);
}

float toRad(float degrees)
{
    return mod(degrees, 360.0) * (PI/180.0);
}

float toNormRad(float degrees)
{
    return toRad(degrees) / (PI*2.0);
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_Res;
    // TODO: does not work above 90 due to wrapping around
    // Need make everything fit and then rotate after...
    float focusColor = 45; // does not support 0.0, 90.0
    float focusSize = 5;

    vec2 toCenter = vec2(0.5) - st;
    float angle = max(atan(toCenter.y, toCenter.x) + PI, 0.0);
    float radius = length(toCenter)*2.0;
    float focusWedge0 = toRad(focusColor);
    float focusWedge1 = toRad(focusColor+270);
    float shapedAngle = querpP(
        angle,
        vec2(min(focusWedge0, focusWedge1), toNormRad(focusColor)),
        vec2(max(focusWedge0, focusWedge1), toNormRad(focusColor+focusSize))
    );
    vec3 color = hsb2rgb(vec3(shapedAngle, radius, 1.0));

    color *= 1.0-step(0.5, length(toCenter)); // make circle
    gl_FragColor = vec4(color, 1.0);
}
