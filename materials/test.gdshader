shader_type spatial;



void vertex() {
	VERTEX.y += sin(TIME * 10.0 + VERTEX.x * 15.0) * 0.01;
	VERTEX.x += sin(TIME * 5.0 + VERTEX.y * 40.0) * 0.02;
	VERTEX.z += sin(TIME * 15.0 + VERTEX.y * 30.0) * 0.02;
}

void fragment() {
	EMISSION = vec3(1,10,20) * 0.2;
	ALPHA = 1.0;
}
