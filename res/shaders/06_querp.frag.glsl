#version 330 core

in vec2 vTexCoord;

uniform vec2 u_Mouse;
uniform vec2 u_Res;
uniform float u_Time;

float plot(vec2 st, float pct)
{
    return smoothstep(pct-0.02, pct, st.y) - smoothstep(pct, pct+0.02, st.y);
}

// Quadruple Lerp
float querp(float x, vec2 a, vec2 b, vec2 c, vec2 d)
{
    float s0 = (b.y-a.y)/(b.x-a.x);
    float s1 = (c.y-b.y)/(c.x-b.x);
    float s2 = (d.y-c.y)/(d.x-c.x);

    float fx = (x*s0) + (a.y) - (a.x*s0);
    float fbx = (b.x*s0) + (a.y) - (a.x*s0);
    float gx = (x*s1) + (fbx) - (b.x*s1);
    float gcx = (c.x*s1) + (fbx) - (b.x*s1);
    float hx = (x*s2) + (gcx) - (c.x*s2);

    float selNone = 1.0-step(a.x, x) + step(d.x, x);
    float selF = max(1.0-step(b.x, x) - selNone, 0.0);
    float selG = max(1.0-step(c.x, x) - selF - selNone, 0.0);
    float selH = max(1.0-step(d.x, x) - selG - selF - selNone, 0.0);

    return (fx*selF) + (gx*selG) + (hx*selH);
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_Res;

    float y = querp(
        st.x,
        vec2(0.0),
        vec2(0.2, 0.5),
        vec2(0.6, 0.6),
        vec2(1.0)
    );
    float pct = plot(st, y);
    vec3 color = (1.0-pct)*vec3(y) + pct*vec3(0.0, 1.0, 0.0);

    gl_FragColor = vec4(color, 1.0);
}
