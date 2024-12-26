#version 330 core

#define PI 3.14159265358979323

in vec2 vTexCoord;

uniform vec2 u_Mouse;
uniform vec2 u_Res;
uniform float u_Time;

float selGear(float angle, float radius, float numTeeth, float toothW, float coreR, float toothR)
{
    toothW = toothW*2.0 - 1.0;
    toothR -= coreR;
    float gearF = step(toothW, cos(angle * numTeeth))*toothR + coreR;

    return 1.0-smoothstep(gearF-0.02, gearF, radius);
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_Res;
    vec2 pos = vec2(0.5) - st;
    float r = length(pos) * 2.0;
    float a = atan(pos.y, pos.x);
    a = mod(atan(pos.y, pos.x) + u_Time, PI*2.0);

    float f = cos(a * 3.0);
    f = abs(cos(a * 3.0));
    f = abs(cos(a * 2.5))*0.5 + 0.3;
    f = abs(cos(a * 12.0) * sin(a * 3.))*0.8 + 0.1;
    f = smoothstep(-0.5, 1.0, cos(a * 10.0))*0.2 + 0.5;

    vec3 color = vec3(1.0-smoothstep(f-0.02, f, r));
    color = vec3(
        selGear(a, r, 10.0, 0.5, 0.9, 0.8) - selGear(a, r, 10.0, 0.5, 0.4, 0.5)
    );
    gl_FragColor = vec4(color, 1.0);
}
