shader_type spatial;

void vertex() {
	VERTEX.y += sin(TIME * 7.0 + VERTEX.y * 7.0 ) * 0.10;
	VERTEX.x += sin(TIME * 7.0 + VERTEX.x * 21.0) * 0.01;
	VERTEX.z += sin(TIME * 12.0 + VERTEX.z * 33.0) * 0.01;
}

void fragment() {
	EMISSION = vec3(2,0.2,0.1) * 1000.0;
	ALPHA = 1.0;
}
