#version 330 core

in vec2 vTexCoord;

uniform vec2 u_Mouse;
uniform vec2 u_Res;
uniform float u_Time;

float plot(vec2 st, float pct)
{
    return smoothstep(pct-0.02, pct, st.y) - smoothstep(pct, pct+0.02, st.y);
}

float breakstep(float x, float minB, float maxB, float range, float breakSlope)
{
    float cS = (1.0-((maxB-minB)*breakSlope)) / (range-(maxB-minB));
    float fx = x*cS;
    float fmin = minB*cS;
    float gx = (x*breakSlope) + (fmin) - (minB*breakSlope);
    float gmax = (maxB*breakSlope) + (fmin) - (minB*breakSlope);
    float hx = (x*cS) + (gmax) - (maxB*cS);

    float zMinSel = 1.0-step(minB, x);
    float minMaxSel = max(1.0-step(maxB, x) - zMinSel, 0.0);
    float maxRangeSel = max(1.0 - zMinSel - minMaxSel, 0.0);

    return (fx*zMinSel) + (gx*minMaxSel) + (hx*maxRangeSel);
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_Res;

    float y = breakstep(st.x, 0.1, 0.9, 1.0, 0.1);
    float pct = plot(st, y);
    vec3 color = (1.0-pct)*vec3(y) + pct*vec3(0.0, 1.0, 0.0);

    gl_FragColor = vec4(color, 1.0);
};
