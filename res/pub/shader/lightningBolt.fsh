

#ifdef GL_ES
precision mediump float;
#endif

varying vec2 v_texCoord;
varying vec4 v_color;
uniform float color_r;
uniform float color_g;
uniform float color_b;
//uniform sampler2D CC_Texture0;
uniform float u_opacity;

void main() {    
    vec4 c = texture2D(CC_Texture0, v_texCoord)*v_color;
	c *= vec4(color_r, color_g, color_b, 1);
	gl_FragColor = c*u_opacity;
}

