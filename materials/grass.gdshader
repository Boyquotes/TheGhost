shader_type spatial;
render_mode diffuse_toon;
render_mode cull_disabled;
render_mode specular_toon;

uniform vec4 albedo : source_color = vec4(0.09, 0.12, 0.02, 1.0);

uniform vec3 player_pos = vec3(0.0);
uniform float interact_power = 0.05;
uniform float radius = 7.0;

void vertex() {
	vec3 world_vert = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz; // model space to world space
	vec3 direction = world_vert - player_pos;
	direction.y = 0.0;
	direction = normalize(direction);
	float dist = distance(player_pos, world_vert);
	float power = smoothstep(radius, 0.0, dist);
	direction = (vec4(direction, 1.0) * MODEL_MATRIX).xyz; // world space direction to model space
	VERTEX += direction * power * interact_power * (1.0 - UV.y);
}

void fragment() {
	ALBEDO = albedo.rgb;
	
}