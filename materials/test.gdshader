shader_type spatial;



void vertex() {
	//VERTEX.y += sin(TIME * 10.0 + VERTEX.x * 10.0) * 0.01;
	//VERTEX.x += sin(TIME * 10.0 + VERTEX.y * 10.0) * 0.01;
}

void fragment() {
	EMISSION = vec3(1,5,10) * 0.5;
}
