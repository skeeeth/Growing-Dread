shader_type canvas_item;

uniform float intensity: hint_range(0.0, 1.0, 0.1);
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.r = 1.0 - (1.0 - texture(TEXTURE,UV)).r * intensity;
	COLOR.g = 1.0 - (1.0 - texture(TEXTURE,UV)).g * intensity;
	COLOR.b = 1.0 - (1.0 - texture(TEXTURE,UV)).b * intensity;
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
