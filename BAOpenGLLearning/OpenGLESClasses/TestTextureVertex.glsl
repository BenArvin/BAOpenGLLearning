#version 300 es

layout(location = 0) in vec3 aPos;
layout(location = 1) in vec2 aTexCoord;
layout(location = 2) in vec2 bTexCoord;

out vec2 v_texCoord_a;
out vec2 v_texCoord_b;

void main(void) {
    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
    v_texCoord_a = aTexCoord;
    v_texCoord_b = bTexCoord;
}
