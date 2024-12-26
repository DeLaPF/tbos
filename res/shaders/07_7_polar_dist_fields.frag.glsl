#version 330 core

#define PI 3.14159265358979323

in vec2 vTexCoord;

uniform vec2 u_Mouse;
uniform vec2 u_Res;
uniform float u_Time;

float circleDF(vec2 p, vec2 o)
{
    return length(p-o);
}

float polygonDF(vec2 p, int sides, vec2 o)
{
    p -= o;
    // Angle and radius from the current pixel
    float a = atan(p.x, p.y)+PI;
    float r = (PI * 2.0) / float(sides);

    // Shaping function that modulate the dipance
    return cos(floor(0.5 + a/r)*r - a)*length(p);
}

float polygon(vec2 p, int sides, float wh, vec2 o)
{
    return 1.0-smoothstep(wh-0.01, wh, polygonDF(p, sides, o));
}

void main()
{
    vec3 color = vec3(0.0);
    vec2 st = gl_FragCoord.xy/u_Res;
    st = st*2.0 - 1.0; // map [0,1] to [-1, 1]
    st.x *= u_Res.x/u_Res.y; // fix aspect ratio stretch

    // single shape
    // color = vec3(polygon(st, 8, 0.3, vec2(0.0)));

    // hall(like) effect
    // float df = polygonDF(st, 8, vec2(0.0));
    // color = vec3(df*step(0.1, df));

    // some combinations
    // float sqDF0 = polygonDF(st, 4, vec2(0.4));
    // float sqDF1 = polygonDF(st, 4, vec2(0.0));
    // float mn = min(sqDF0, sqDF1); // union
    // float mx = max(sqDF0, sqDF1); // intersect
    // float pw0 = pow(sqDF0, sqDF1);
    // float pw1 = pow(sqDF1, sqDF0);
    // color = vec3(1.0-step(0.5, mn));
    // color = vec3(1.0-step(0.5, mx));
    // color = vec3(1.0-step(0.5, pw0));
    // color = vec3(1.0-step(0.5, pw1));

    // cr
    vec3 orange = vec3(1.0, 0.392, 0.0392);
    float sel0 = 1.0-step(0.5, circleDF(st, vec2(0.0)));
    float negSel0 = 1.0-step(0.42, circleDF(st, vec2(0.1, -0.1)));
    sel0 = max(sel0-negSel0, 0.0);
    float sel1 = 1.0-step(0.35, circleDF(st, vec2(0.1, -0.1)));
    float negSel1 = 1.0-step(0.15, circleDF(st, vec2(0.33, 0.04)));
    sel1 = max(sel1-negSel1, 0.0);
    color = sel0*orange;
    color = mix(color, sel1*orange, sel1);

    gl_FragColor = vec4(color, 1.0);
}
