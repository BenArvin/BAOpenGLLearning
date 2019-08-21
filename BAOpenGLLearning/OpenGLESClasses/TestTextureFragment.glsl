#version 300 es

precision mediump float;

out vec4 FragColor;

in vec2 v_texCoord_a;
in vec2 v_texCoord_b;

uniform sampler2D texture_a;
uniform sampler2D texture_b;

void main(void) {
//    FragColor = texture(texture_a, v_texCoord_a);
//    FragColor = texture(texture_b, v_texCoord_b);
//    FragColor = vec4(texture(texture_a, v_texCoord_a).r, 0.0, 0.0, 1.0);
//    FragColor = mix(texture(texture_a, v_texCoord_a), texture(texture_b, v_texCoord_b), 1.0);
    if (v_texCoord_a.x > 0.0 && v_texCoord_a.x < 0.33 && v_texCoord_a.y > 0.0 && v_texCoord_a.y < 0.33) {
        if (v_texCoord_b.x > 0.25 && v_texCoord_b.x < 0.75 && v_texCoord_b.y > 0.25 && v_texCoord_b.y < 0.75) {
            FragColor = mix(texture(texture_b, v_texCoord_b), vec4(0.0, 0.0, 0.0, 0.5), 0.7);
        } else {
            FragColor = texture(texture_b, v_texCoord_b);
        }
    } else {
        FragColor = texture(texture_a, v_texCoord_a);
    }
}
