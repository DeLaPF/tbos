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

const vec3 black = vec3(0.078, 0.039, 0.075);
const vec3 white = vec3(0.941, 0.914, 0.843);
const vec3 red = vec3(0.663, 0.129, 0.137);
const vec3 blue = vec3(0.0, 0.369, 0.596);
const vec3 yellow = vec3(0.988, 0.777, 0.149);

// TODO: (once I learn how) add texture/imperfections with noise
void main()
{
    vec2 st = gl_FragCoord.xy/u_Res;

    // l-r, t-b
    // r1
    float ss0 = selSquare(st, vec2(0.0, 0.8), vec2(0.06, 1.0), 0.0);
    float ss1 = selSquare(st, vec2(0.09, 0.8), vec2(0.21, 1.0), 0.0);
    float ss2 = selSquare(st, vec2(0.24, 0.8), vec2(0.72, 1.0), 0.0);
    float ss3 = selSquare(st, vec2(0.75, 0.8), vec2(0.93, 1.0), 0.0);
    float ss4 = selSquare(st, vec2(0.96, 0.8), vec2(1.0, 1.0), 0.0);
    // r2
    float ss5 = selSquare(st, vec2(0.0, 0.57), vec2(0.06, 0.77), 0.0);
    float ss6 = selSquare(st, vec2(0.09, 0.57), vec2(0.21, 0.77), 0.0);
    float ss7 = selSquare(st, vec2(0.24, 0.57), vec2(0.72, 0.77), 0.0);
    float ss8 = selSquare(st, vec2(0.75, 0.57), vec2(0.93, 0.77), 0.0);
    float ss9 = selSquare(st, vec2(0.96, 0.57), vec2(1.0, 0.77), 0.0);
    // r3
    float ss10 = selSquare(st, vec2(0.0, 0.0), vec2(0.21, 0.54), 0.0);
    float ss11 = selSquare(st, vec2(0.24, 0.13), vec2(0.72, 0.54), 0.0);
    float ss12 = selSquare(st, vec2(0.75, 0.13), vec2(0.93, 0.54), 0.0);
    float ss13 = selSquare(st, vec2(0.96, 0.13), vec2(1.0, 0.54), 0.0);
    // r4
    float ss14 = selSquare(st, vec2(0.24, 0.0), vec2(0.72, 0.1), 0.0);
    float ss15 = selSquare(st, vec2(0.75, 0.0), vec2(0.93, 0.1), 0.0);
    float ss16 = selSquare(st, vec2(0.96, 0.0), vec2(1.0, 0.1), 0.0);

    vec3 color = black;
    // r1
    color = mix(color, red, ss0);
    color = mix(color, red, ss1);
    color = mix(color, white, ss2);
    color = mix(color, white, ss3);
    color = mix(color, yellow, ss4);
    // r2
    color = mix(color, red, ss5);
    color = mix(color, red, ss6);
    color = mix(color, white, ss7);
    color = mix(color, white, ss8);
    color = mix(color, yellow, ss9);
    // r3
    color = mix(color, white, ss10);
    color = mix(color, white, ss11);
    color = mix(color, white, ss12);
    color = mix(color, white, ss13);
    // r4
    color = mix(color, white, ss14);
    color = mix(color, blue, ss15);
    color = mix(color, blue, ss16);

    gl_FragColor = vec4(color, 1.0);
};
