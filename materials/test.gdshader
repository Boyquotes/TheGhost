shader_type spatial;



void vertex() {
	VERTEX.y += sin(TIME * 20.0 + VERTEX.x * 15.0) * 0.04;
	VERTEX.x += sin(TIME * 10.0 + VERTEX.y * 40.0) * 0.04;
	VERTEX.z += sin(TIME * 30.0 + VERTEX.y * 30.0) * 0.04;
}

void fragment() {
	EMISSION = vec3(1,10,20) * 0.2;
	ALPHA = 1.0;
}
