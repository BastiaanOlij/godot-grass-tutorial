shader_type spatial;

uniform sampler2D albedo : hint_albedo;
uniform sampler2D normalmap : hint_normal;

uniform sampler2D heightmap;
uniform float amplitude = 15.0;

float get_height(vec2 pos) {
	pos -= vec2(150.0, 150.0);
	pos /= vec2(300.0, 300.0);
	return amplitude * texture(heightmap, pos).r;
}

void vertex() {
	VERTEX.y = get_height(VERTEX.xz);
	
	TANGENT = normalize(vec3(1.0, get_height(VERTEX.xz + vec2(1.0, 0.0)) - VERTEX.y, 0.0));
	BINORMAL = normalize(vec3(0.0, get_height(VERTEX.xz + vec2(0.0, 1.0)) - VERTEX.y, 1.0));
	NORMAL = cross(BINORMAL, TANGENT);
}

void fragment() {
	ALBEDO = texture(albedo, UV * 10.0).rgb;
	NORMALMAP = texture(normalmap, UV * 10.0).rgb;
}