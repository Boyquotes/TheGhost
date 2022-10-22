shader_type spatial;

void vertex() {
	VERTEX.y += sin(TIME * 7.0 + VERTEX.y * 7.0 ) * 0.10;
	VERTEX.x += sin(TIME * 7.0 + VERTEX.x * 7.0) * 0.10;
	VERTEX.z += sin(TIME * 7.0 + VERTEX.z * 7.0) * 0.10;
}

void fragment() {
	EMISSION = vec3(100,10,5) * 1.0;
	ALPHA = 1.0;
}
