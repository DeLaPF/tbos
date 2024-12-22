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

    // We map x (0.0 - 1.0) to the hue (0.0 - 1.0)
    // And the y (0.0 - 1.0) to the brightness
    color = hsb2rgb(vec3(st.x, 1.0, st.y));

    gl_FragColor = vec4(color, 1.0);
}
