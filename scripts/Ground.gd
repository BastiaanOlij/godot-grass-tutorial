extends MeshInstance

func _ready():
	# upscale, we can't subdivide by more then 100 in the property inspector
	mesh.size = Vector2(300.0, 300.0);
	mesh.subdivide_width = 299;
	mesh.subdivide_depth = 299;

