#shader vertex
#version 330 core

layout(location = 0) in vec4 pos;
layout(location = 1) in vec2 texCoord;

out vec2 vTexCoord;

void main()
{
    vTexCoord = texCoord;
    gl_Position = pos;
};

#shader fragment
#version 330 core

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

    float y = pow(st.x, 5.0); // y = x^n
    float pct = plot(st, y);
    vec3 color = (1.0-pct)*vec3(y) + pct*vec3(0.0, 1.0, 0.0);

    gl_FragColor = vec4(color, 1.0);
};
