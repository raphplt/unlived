class_name Visitor
extends CharacterBody3D

var camera: Camera3D
var enabled := false
var movement_locked := false
var sensitivity := 0.0022
var walk_speed := 2.5
var step_distance := 0.0
signal footstep

func _ready() -> void:
	collision_layer = 2
	collision_mask = 1
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.24
	capsule.height = 1.7
	var collision := CollisionShape3D.new()
	collision.shape = capsule
	collision.position.y = 0.87
	add_child(collision)
	camera = Camera3D.new()
	camera.position.y = 1.64
	camera.fov = 72
	camera.near = 0.05
	add_child(camera)
	camera.make_current()
	floor_snap_length = 0.2

func _unhandled_input(event: InputEvent) -> void:
	if enabled and event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * sensitivity)
		camera.rotation.x = clampf(camera.rotation.x - event.relative.y * sensitivity, -1.35, 1.35)

func _physics_process(delta: float) -> void:
	if movement_locked:
		velocity = Vector3.ZERO
		return
	var direction := Vector3.ZERO
	if enabled:
		var input := Vector2(
			float(Input.is_physical_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT)) - float(Input.is_physical_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT)),
			float(Input.is_physical_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN)) - float(Input.is_physical_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP)))
		direction = (basis * Vector3(input.x, 0, input.y)).normalized()
	velocity.x = move_toward(velocity.x, direction.x * walk_speed, delta * 12.0)
	velocity.z = move_toward(velocity.z, direction.z * walk_speed, delta * 12.0)
	if not is_on_floor():
		velocity.y -= 14.0 * delta
	else:
		velocity.y = 0.0
	move_and_slide()
	if enabled and is_on_floor():
		step_distance += Vector2(velocity.x, velocity.z).length() * delta
		if step_distance > 1.65:
			step_distance = 0.0
			footstep.emit()

func place(at: Vector3, yaw: float = 0.0) -> void:
	position = at
	rotation = Vector3(0, yaw, 0)
	camera.rotation = Vector3.ZERO
	velocity = Vector3.ZERO

func target() -> String:
	var from := camera.global_position
	var query := PhysicsRayQueryParameters3D.create(from, from - camera.global_basis.z * 3.0, 5)
	query.collide_with_areas = true
	query.exclude = [get_rid()]
	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	if not hit.is_empty() and hit.collider.has_meta("interaction"):
		return str(hit.collider.get_meta("interaction"))
	return ""
