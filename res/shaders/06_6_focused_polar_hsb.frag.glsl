#version 330 core

#define PI 3.14159265358979323

in vec2 vTexCoord;

uniform vec2 u_Mouse;
uniform vec2 u_Res;
uniform float u_Time;

float terp(float x, vec2 a, vec2 b)
{
    float s0 = a.y/a.x;
    float s1 = (b.y-a.y)/(b.x-a.x);

    float fx = x*s0;
    float fax = a.x*s0;
    float gx = (x*s1) + (fax) - (a.x*s1);

    float selF = 1.0-step(a.x, x);
    float selG = max(1.0-step(b.x, x) - selF, 0.0);

    return (fx*selF) + (gx*selG);
}

float terpP(float rad, float fWidth)
{
    float w = min(fWidth, 0.99);
    float x = mod(rad, PI*2.0);
    return terp(x, vec2((PI*3.0)/2.0, w), vec2(PI*2.0, 1.0));
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
    float focusColor = 225.0;
    float focusWidth = 90.0;

    vec2 toCenter = vec2(0.5) - st;
    float angle = max(atan(toCenter.y, toCenter.x) + PI, 0.0);
    float radius = length(toCenter)*2.0;

    float transAngle = mod(angle-toNormRad(focusColor), PI*2.0);
    float shapedAngle = terpP(transAngle, toNormRad(focusWidth));
    float untransShaped = mod(shapedAngle+toNormRad(focusColor), 1.0);

    vec3 color = hsb2rgb(vec3(untransShaped, radius, 1.0));
    color *= 1.0-step(0.5, length(toCenter)); // make circle
    gl_FragColor = vec4(color, 1.0);
}
