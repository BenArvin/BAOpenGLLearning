#version 300 es

precision mediump float;

out vec4 FragColor;
in vec3 v_color;

void main(void) {
    FragColor = vec4(v_color, 1.0);
}
