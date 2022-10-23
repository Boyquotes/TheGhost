shader_type spatial;

void vertex() {
	VERTEX.y -= sin(TIME * 22.0 + VERTEX.y * 33.0) * 0.10;
	VERTEX.x -= sin(TIME * 22.0 + VERTEX.x * 33.0) * 0.10;
	VERTEX.z -= sin(TIME * 22.0 + VERTEX.z * 33.0) * 0.10;
}

void fragment() {
	EMISSION = vec3(5,10,100) * 20.0;
	ALPHA = 1.0;
}
