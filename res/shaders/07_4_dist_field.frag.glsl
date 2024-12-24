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

    float cdf0 = circleDF(st, vec2(0.2, 0.2));
    float cdf1 = circleDF(st, vec2(0.2, 0.8));
    float cdf2 = circleDF(st, vec2(0.8, 0.2));
    float cdf3 = circleDF(st, vec2(0.8, 0.8));

    float mm = min(cdf0, min(cdf1, min(cdf2, cdf3)));
    // float temp = circleDF(st, vec2(0.5));
    // float temp = circleDF(st, vec2(0.4)) + circleDF(st, vec2(0.6));
    // float temp = circleDF(st, vec2(0.4)) * circleDF(st, vec2(0.6));
    // float temp = min(circleDF(st, vec2(0.4)), circleDF(st, vec2(0.6)));
    // float temp = max(circleDF(st, vec2(0.4)), circleDF(st, vec2(0.6)));
    // float temp = pow(circleDF(st, vec2(0.4)), circleDF(st, vec2(0.6)));
    // float temp = mod(circleDF(st, vec2(0.5))*16.0, 1.0);
    // float temp = mod((1.0-circleDF(st, vec2(0.5)))*16.0, 1.0);
    float temp = mod((1.0-circleDF(st, vec2(0.5)))*16.0, abs(sin(u_Time))+1.2);

    vec3 color = vec3(temp);
    // vec3 color = vec3(abs(sin(mm*100.0)));

    gl_FragColor = vec4(color, 1.0);
}
