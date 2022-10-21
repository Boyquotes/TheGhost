shader_type spatial;



void vertex() {
	VERTEX.y += sin(TIME * 10.0 + VERTEX.x * 10.0) * 0.10;
	VERTEX.x += sin(TIME * 10.0 + VERTEX.y * 10.0) * 0.10;
	VERTEX.z += sin(TIME * 10.0 + VERTEX.y * 10.0) * 0.10;
}

void fragment() {
	EMISSION = vec3(100,10,5) * 1.0;
	ALPHA = 1.0;
}
