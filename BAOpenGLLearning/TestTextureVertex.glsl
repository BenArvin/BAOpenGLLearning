#version 300 es

layout(location = 0) in vec3 aPos;
layout(location = 1) in vec3 aColor;
layout(location = 2) in vec2 aTexCoord;

out vec3 v_color;
out vec2 v_texCoord;

void main(void) {
    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
    v_color = aColor;
    v_texCoord = aTexCoord;
}
