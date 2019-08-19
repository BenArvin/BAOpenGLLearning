#version 300 es

precision mediump float;

out vec4 FragColor;
in vec3 v_color;
in vec2 v_texCoord;

uniform sampler2D texture1;

void main(void) {
    FragColor = texture(texture1, v_texCoord);
}
