shader_type spatial;

void vertex() {
	VERTEX.y += sin(TIME * 14.0) * 0.10;
	VERTEX.x += sin(TIME * 7.0) * 0.10;
	VERTEX.z += sin(TIME * 21.0) * 0.10;
}

void fragment() {
	EMISSION = vec3(5,10,100) * 1.0;
	ALPHA = 1.0;
}
