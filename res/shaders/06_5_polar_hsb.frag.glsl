#version 330 core

#define PI 3.14159265358979323

in vec2 vTexCoord;

uniform vec2 u_Mouse;
uniform vec2 u_Res;
uniform float u_Time;

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

void main()
{
    vec2 st = gl_FragCoord.xy/u_Res;
    vec3 color = vec3(0.0);

    // Use polar coordinates instead of cartesian
    vec2 toCenter = vec2(0.5) - st;
    float angle = atan(toCenter.y, toCenter.x);
    float radius = length(toCenter)*2.0;

    // animate rotation
    // angle = mod(angle+u_Time, PI*2.0); // fun mistake
    angle = mod(angle+(u_Time*2.0), PI*2.0);

    // Map the angle (-PI to PI) to the Hue (from 0 to 1)
    // and the Saturation to the radius
    color = hsb2rgb(vec3((angle/(PI*2.0))+0.5, radius, 1.0));

    gl_FragColor = vec4(color,1.0);
}
