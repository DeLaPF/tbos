#version 330 core

in vec2 vTexCoord;

uniform vec2 u_Mouse;
uniform vec2 u_Res;
uniform float u_Time;

float selSquare(vec2 p, vec2 minB, vec2 maxB, float blur)
{
    vec2 aboveMinB = smoothstep(minB, minB+vec2(blur), p);
    vec2 belowMaxB = 1.0-smoothstep(maxB-vec2(blur), maxB, p);

    return aboveMinB.x*aboveMinB.y*belowMaxB.x*belowMaxB.y;
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_Res;

    float ss0 = selSquare(st, vec2(0.2), vec2(0.6), 0.01);
    vec3 ss0Color = vec3(1.0, 0.0, 0.0)*ss0;

    gl_FragColor = vec4(ss0Color, 1.0);
};
