shader_type particles;

uniform float rows = 16;
uniform float spacing = 1.0;

uniform sampler2D heightmap;
uniform float amplitude = 15.0;
uniform vec2 heightmap_size = vec2(300.0, 300.0);

uniform sampler2D noisemap;

float get_height(vec2 pos) {
	pos -= 0.5 * heightmap_size;
	pos /= heightmap_size;
	
	return amplitude * texture(heightmap, pos).r;
}

void vertex() {
	// obtain our position based on which particle we're rendering
	vec3 pos = vec3(0.0, 0.0, 0.0);
	pos.z = float(INDEX);
	pos.x = mod(pos.z, rows);
	pos.z = (pos.z - pos.x) / rows;
	
	// center this
	pos.x -= rows * 0.5;
	pos.z -= rows * 0.5;
	
	// and now apply our spacing
	pos *= spacing;
	
	// now center on our particle location but within our spacing
	pos.x += EMISSION_TRANSFORM[3][0] - mod(EMISSION_TRANSFORM[3][0], spacing);
	pos.z += EMISSION_TRANSFORM[3][2] - mod(EMISSION_TRANSFORM[3][2], spacing);
	
	// now add some noise based on our _world_ position
	vec3 noise = texture(noisemap, pos.xz * 0.001).rgb;
	pos.x += noise.x * spacing;
	pos.z += noise.y * spacing;
	
	// apply our height
	pos.y = get_height(pos.xz);
	
	float y2 = get_height(pos.xz + vec2(1.0, 0.0));
	float y3 = get_height(pos.xz + vec2(0.0, 1.0));
	
	if (abs(y2 - pos.y) > 0.5) {
		pos.y = -10000.0;
	} else if (abs(y3 - pos.y) > 0.5) {
		pos.y = -10000.0;
	}
	
	// rotate our transform
	TRANSFORM[0][0] = cos(noise.z * 3.0);
	TRANSFORM[0][2] = -sin(noise.z * 3.0);
	TRANSFORM[2][0] = sin(noise.z * 3.0);
	TRANSFORM[2][2] = cos(noise.z * 3.0);
	
	// update our transform to place
	TRANSFORM[3][0] = pos.x;
	TRANSFORM[3][1] = pos.y;
	TRANSFORM[3][2] = pos.z;
}