#version 330 core

in vec2 vTexCoord;

uniform vec2 u_Mouse;
uniform vec2 u_Res;
uniform float u_Time;

float circleDF(vec2 p, vec2 origin)
{
    return length(p-origin);
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_Res;
    st = st*2.0 - 1.0;

    float df = length(abs(st)-0.3);
    df = length(min(abs(st)-0.3, 0.0));
    df = length(max(abs(st)-0.3, 0.0));

    float sel = fract(df * 10.0);
    // sel = step(0.3, df);
    // sel = step(0.3, df) * step(df, 0.4);
    // sel = smoothstep(0.3, 0.4, df) * smoothstep(0.6, 0.5, df);

    vec3 color = vec3(sel);
    gl_FragColor = vec4(color, 1.0);
}
