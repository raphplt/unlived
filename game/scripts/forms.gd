class_name Forms
extends RefCounted
## Small geometry vocabulary. All dimensions are metres; +Z is the front.

static var surface: Shader = preload("res://shaders/surface.gdshader")
static var serif: Font = preload("res://assets/fonts/Cormorant.ttf")
static var sans: Font = preload("res://assets/fonts/Inter.ttf")

static func material(color: String, roughness: float = 0.8, metal: float = 0.0, glow: float = 0.0) -> ShaderMaterial:
	var mat := ShaderMaterial.new()
	mat.shader = surface
	mat.set_shader_parameter("tint", Color(color))
	mat.set_shader_parameter("roughness_value", roughness)
	mat.set_shader_parameter("metallic_value", metal)
	mat.set_shader_parameter("emission_strength", glow)
	return mat

static func box(parent: Node3D, at: Vector3, size: Vector3, mat: Material, solid: bool = false) -> MeshInstance3D:
	var mesh := BoxMesh.new()
	mesh.size = size
	return shape(parent, at, mesh, mat, solid)

static func cylinder(parent: Node3D, at: Vector3, radius: float, height: float, mat: Material, top: float = -1.0, solid: bool = false) -> MeshInstance3D:
	var mesh := CylinderMesh.new()
	mesh.bottom_radius = radius
	mesh.top_radius = radius if top < 0.0 else top
	mesh.height = height
	mesh.radial_segments = 48
	return shape(parent, at, mesh, mat, solid)

static func sphere(parent: Node3D, at: Vector3, radius: float, mat: Material) -> MeshInstance3D:
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	return shape(parent, at, mesh, mat)

static func shape(parent: Node3D, at: Vector3, mesh: Mesh, mat: Material, solid: bool = false) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.mesh = mesh
	instance.material_override = mat
	instance.position = at
	parent.add_child(instance)
	if solid:
		instance.create_trimesh_collision()
	return instance

static func text(parent: Node3D, at: Vector3, words: String, size: int, color: String = "ded4bd", elegant: bool = false) -> Label3D:
	var label := Label3D.new()
	label.text = words
	label.font = serif if elegant else sans
	label.font_size = size
	label.pixel_size = 0.003
	label.modulate = Color(color)
	label.outline_size = 0
	label.no_depth_test = false
	label.position = at
	parent.add_child(label)
	return label

static func target(parent: Node3D, at: Vector3, size: Vector3, id: String) -> Area3D:
	var area := Area3D.new()
	area.position = at
	area.collision_layer = 4
	area.collision_mask = 0
	area.set_meta("interaction", id)
	var collider := CollisionShape3D.new()
	var shape_box := BoxShape3D.new()
	shape_box.size = size
	collider.shape = shape_box
	area.add_child(collider)
	parent.add_child(area)
	return area

static func lamp(parent: Node3D, at: Vector3, color: String, energy: float, radius: float, shadows: bool = false) -> OmniLight3D:
	var light := OmniLight3D.new()
	light.position = at
	light.light_color = Color(color)
	light.light_energy = energy
	light.omni_range = radius
	light.omni_attenuation = 1.4
	light.shadow_enabled = shadows
	parent.add_child(light)
	return light

static func arch(parent: Node3D, at: Vector3, radius: float, height: float, mat: Material) -> void:
	for side in [-1, 1]:
		box(parent, at + Vector3(side * radius, height * 0.5, 0), Vector3(0.13, height, 0.2), mat)
	for i in range(32):
		var angle := PI * (float(i) + 0.5) / 32.0
		var segment := box(parent, at + Vector3(cos(angle) * radius, height + sin(angle) * radius, 0), Vector3(PI * radius / 32.0 + 0.025, 0.13, 0.2), mat)
		segment.rotation.z = angle + PI * 0.5

static func picture(parent: Node3D, at: Vector3, size: Vector2, texture: Texture2D, frame_mat: Material) -> Node3D:
	var root := Node3D.new()
	parent.add_child(root)
	root.position = at
	box(root, Vector3.ZERO, Vector3(size.x + 0.08, size.y + 0.08, 0.055), frame_mat)
	var mat := StandardMaterial3D.new()
	mat.albedo_texture = texture
	mat.roughness = 1.0
	var quad := QuadMesh.new()
	quad.size = size
	shape(root, Vector3(0, 0, 0.031), quad, mat)
	return root
