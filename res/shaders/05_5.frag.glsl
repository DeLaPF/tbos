#version 330 core

#define PI 3.14159265358979323

in vec2 vTexCoord;

uniform vec2 u_Mouse;
uniform vec2 u_Res;
uniform float u_Time;

float plot(vec2 st, float pct)
{
    return smoothstep(pct-0.02, pct, st.y) - smoothstep(pct, pct+0.02, st.y);
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_Res;

    float y = sin((st.x+u_Time/2.0)*PI*6.0)/2.0 + 0.5;
    float pct = plot(st, y);
    vec3 color = (1.0-pct)*vec3(y) + pct*vec3(0.0, 1.0, 0.0);

    gl_FragColor = vec4(color, 1.0);
};
