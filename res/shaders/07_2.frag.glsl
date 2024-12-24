#version 330 core

in vec2 vTexCoord;

uniform vec2 u_Mouse;
uniform vec2 u_Res;
uniform float u_Time;

float selCircle(vec2 p, vec2 origin, float radius, float blur)
{
    float toCenter = length(p-origin);

    return 1.0-smoothstep(radius-(radius*blur), radius, toCenter);
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_Res;
    float ss0 = selCircle(st, vec2(1.0), 0.5, 0.05);

    gl_FragColor = vec4(ss0*vec3(1.0, 0.0, 0.0), 1.0);
}
