shader_type canvas_item;
uniform sampler2D noise;
uniform float melt_p;
uniform sampler2D screen_texture: hint_screen_texture, repeat_disable;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float y_change = texture(noise,vec2(UV.x,0.0)).g * melt_p;
	vec2 read_uv = (vec2(SCREEN_UV.x,SCREEN_UV.y + y_change));
	COLOR = texture(screen_texture,read_uv);
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
