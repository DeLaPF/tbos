#version 330 core

#define PI 3.14159265358979323

in vec2 vTexCoord;

uniform vec2 u_Mouse;
uniform vec2 u_Res;
uniform float u_Time;

// domain to range [0, 1]
float breakstep(float x, float minB, float maxB, float domain, float breakSlope)
{
    float cS = (1.0-((maxB-minB)*breakSlope)) / (domain-(maxB-minB));
    float fx = x*cS;
    float fmin = minB*cS;
    float gx = (x*breakSlope) + (fmin) - (minB*breakSlope);
    float gmax = (maxB*breakSlope) + (fmin) - (minB*breakSlope);
    float hx = (x*cS) + (gmax) - (maxB*cS);

    float zMinSel = 1.0-step(minB, x);
    float minMaxSel = max(1.0-step(maxB, x) - zMinSel, 0.0);
    float maxDomainSel = max(1.0 - zMinSel - minMaxSel, 0.0);

    return (fx*zMinSel) + (gx*minMaxSel) + (hx*maxDomainSel);
}

float focusRange(float angle, float min, float max)
{
    return breakstep(angle, min, max, 2.0*PI, 1.0/(16.0*PI));
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

void main()
{
    vec2 st = gl_FragCoord.xy/u_Res;
    float focus = 70;

    vec2 toCenter = vec2(0.5) - st;
    float angle = max(atan(toCenter.y, toCenter.x) + PI, 0.0);
    float radius = length(toCenter)*2.0;
    float shapedAngle = focusRange(angle, toRad(focus), toRad(focus+270));
    vec3 color = hsb2rgb(vec3(shapedAngle, radius, 1.0));

    color *= 1.0-step(0.5, length(toCenter)); // make circle
    gl_FragColor = vec4(color, 1.0);
}
