shader_type canvas_item;
uniform float droop_amount = 0.5;
void vertex() {
	VERTEX.y = mix(VERTEX.y,VERTEX.y+droop_amount,VERTEX.x);
	// Called for every vertex the material is visible on.
}

void fragment() {
	float y = mix(UV.y,UV.y+droop_amount,UV.x);
	COLOR = texture(TEXTURE,vec2(UV.x,y));
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
