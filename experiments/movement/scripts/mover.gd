extends CharacterBody2D
## Shared movement baseline, three mutually exclusive experimental abilities.
signal sounded(kind: String)

const GRAVITY := 1500.0
const RUN_SPEED := 300.0
const JUMP_SPEED := 480.0
const ROPE_REACH := 405.0
const MAX_CHARGE := 0.50

var mode := 0
var accent := Color("dfb978")
var anchors: Array = []
var winds: Array = []
var active := true
var controlled_by_test := false
var test_axis := Vector2.ZERO
var test_jump := false
var test_action := false
var facing := 1.0
var coyote := 0.0
var jump_buffer := 0.0
var charging := false
var charge := 0.0
var support := Vector2.UP
var launch_lock := 0.0
var rope_index := -1
var rope_length := 0.0
var candidate := -1
var gliding := false
var action_was_down := false
var jump_was_down := false
var ability_count := 0
var grounded_before := false
var trail: Array[Vector2] = []
var anim := 0.0
var visual_squash := 0.0
var last_axis := Vector2.ZERO

func _ready() -> void:
	collision_layer = 2
	collision_mask = 1
	var collider := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(20, 32)
	collider.shape = shape
	add_child(collider)
	floor_snap_length = 4
	safe_margin = 0.05

func reset_at(point: Vector2) -> void:
	position = point
	velocity = Vector2.ZERO
	coyote = 0.0
	jump_buffer = 0.0
	charging = false
	charge = 0.0
	launch_lock = 0.0
	rope_index = -1
	possibly_clear_inputs()
	gliding = false
	trail.clear()
	visual_squash = 0.0
	# Clear CharacterBody contact flags immediately after teleporting.
	move_and_slide()

func possibly_clear_inputs() -> void:
	action_was_down = Input.is_action_pressed("ability")
	jump_was_down = Input.is_action_pressed("jump")
	if controlled_by_test:
		test_axis = Vector2.ZERO
		test_jump = false
		test_action = false
		action_was_down = false
		jump_was_down = false

func input_state() -> Dictionary:
	if controlled_by_test:
		return {"axis": test_axis, "jump": test_jump, "action": test_action}
	return {"axis": Input.get_vector("left", "right", "up", "down"),
		"jump": Input.is_action_pressed("jump"), "action": Input.is_action_pressed("ability")}

func _physics_process(delta: float) -> void:
	if not active: return
	var controls := input_state()
	var axis: Vector2 = controls.axis
	var jumping: bool = controls.jump
	var action: bool = controls.action
	var action_pressed := action and not action_was_down
	var jump_pressed := jumping and not jump_was_down
	last_axis = axis
	anim += delta * (2.0 + absf(velocity.x) / 35.0)
	visual_squash = move_toward(visual_squash, 0.0, delta * 4.0)
	launch_lock = maxf(0.0, launch_lock - delta)
	if absf(axis.x) > 0.1: facing = signf(axis.x)
	if is_on_floor(): coyote = 0.10
	else: coyote = maxf(0.0, coyote - delta)
	jump_buffer = 0.12 if jump_pressed else maxf(0.0, jump_buffer - delta)

	# A held action can catch a new wall, but cannot immediately re-grab the
	# surface just left. Jump cancels preparation rather than committing it.
	if mode == 0 and action and not charging and launch_lock <= 0.0:
		if is_on_floor() or is_on_wall():
			charging = true
			charge = 0.0
			support = Vector2.UP if is_on_floor() else get_wall_normal()
			velocity = Vector2.ZERO
	if charging:
		charge = minf(MAX_CHARGE, charge + delta)
		if jump_pressed:
			charging = false
			charge = 0.0
			launch_lock = 0.18
		elif not action:
			launch_from_support(axis)
		else:
			velocity = -support * 12.0
			move_and_slide()
			visual_squash = charge / MAX_CHARGE * 0.22
			finish_frame(action, jumping)
			return

	if mode == 1:
		candidate = nearest_anchor()
		if action_pressed and candidate >= 0:
			rope_index = candidate
			rope_length = global_position.distance_to(anchors[rope_index])
			ability_count += 1
			sounded.emit("catch")
		if rope_index >= 0 and (not action or jump_pressed):
			rope_index = -1
			sounded.emit("release")
		if rope_index >= 0 and not line_clear(anchors[rope_index]):
			rope_index = -1
			sounded.emit("release")

	var was_gliding := gliding
	gliding = mode == 2 and action and not is_on_floor()
	if gliding and not was_gliding:
		ability_count += 1
		sounded.emit("open")
	var acceleration := 2300.0 if is_on_floor() else 850.0
	var target_speed := RUN_SPEED
	if gliding: target_speed = 400.0
	if rope_index >= 0:
		# Pump tangentially; no radial acceleration or automatic winch.
		var radial: Vector2 = (global_position - anchors[rope_index]).normalized()
		var force := Vector2(axis.x * 1150.0, GRAVITY)
		if global_position.distance_to(anchors[rope_index]) >= rope_length - 1.0:
			force -= radial * maxf(0.0, force.dot(radial))
		velocity += force * delta
		velocity = velocity.limit_length(1100.0)
	else:
		# Preserve the initial impulse. Air input brakes deliberately, while
		# neutral input preserves momentum rather than pulling toward zero.
		if launch_lock <= 0.0:
			if absf(axis.x) > 0.1:
				if is_on_floor() or absf(velocity.x) < target_speed or signf(axis.x) != signf(velocity.x):
					velocity.x = move_toward(velocity.x, axis.x * target_speed, acceleration * delta)
			elif is_on_floor():
				velocity.x = move_toward(velocity.x, 0.0, 6200.0 * delta)
		if gliding:
			var in_wind := false
			for region: Rect2 in winds:
				if region.has_point(global_position): in_wind = true
			if in_wind:
				velocity.y = maxf(-340.0, velocity.y - 1050.0 * delta)
			else:
				velocity.y = minf(90.0, velocity.y + 240.0 * delta)
		else:
			velocity.y = minf(950.0, velocity.y + GRAVITY * delta)
	if jump_buffer > 0.0 and coyote > 0.0 and launch_lock <= 0.0:
		velocity.y = -JUMP_SPEED
		jump_buffer = 0.0
		coyote = 0.0
		sounded.emit("jump")
	if jump_was_down and not jumping and velocity.y < -190.0 and launch_lock <= 0.0:
		velocity.y *= 0.52

	grounded_before = is_on_floor()
	move_and_slide()
	if rope_index >= 0:
		constrain_rope()
	if is_on_floor() and not grounded_before:
		visual_squash = 0.18
		sounded.emit("land")
	finish_frame(action, jumping)

func launch_direction(axis: Vector2) -> Vector2:
	var direction := axis
	if direction.length() < 0.3:
		direction = Vector2(facing, -1.0) if support.y < -0.5 else Vector2(support.x, -1.0)
	# Always leave the supporting surface, including horizontal floor aim.
	if support.y < -0.5: direction.y = minf(-0.65, direction.y)
	else: direction.x = support.x * maxf(0.35, absf(direction.x))
	return direction.normalized()

func launch_from_support(axis: Vector2) -> void:
	velocity = launch_direction(axis) * lerpf(570.0, 1030.0, charge / MAX_CHARGE)
	charging = false
	coyote = 0.0
	jump_buffer = 0.0
	launch_lock = 0.16
	ability_count += 1
	sounded.emit("launch")

func line_clear(point: Vector2) -> bool:
	var query := PhysicsRayQueryParameters2D.create(global_position, point, 1)
	return get_world_2d().direct_space_state.intersect_ray(query).is_empty()

func nearest_anchor() -> int:
	var chosen := -1
	var best := INF
	for i in anchors.size():
		var distance: float = global_position.distance_to(anchors[i])
		if distance > ROPE_REACH or distance < 35.0: continue
		if not line_clear(anchors[i]): continue
		# Prefer forward anchors when comparable; preview always shows the
		# exact selection before the player commits to a grip.
		var score := distance
		if (anchors[i].x - global_position.x) * facing < -30.0: score += 110.0
		if score < best:
			best = score
			chosen = i
	return chosen

func constrain_rope() -> void:
	var offset: Vector2 = global_position - anchors[rope_index]
	if offset.length() <= rope_length: return
	var radial := offset.normalized()
	# Collision-aware correction: never teleport through a ledge or wall.
	move_and_collide(-radial * (offset.length() - rope_length))
	velocity -= radial * maxf(0.0, velocity.dot(radial))

func finish_frame(action: bool, jumping: bool) -> void:
	action_was_down = action
	jump_was_down = jumping
	trail.append(global_position)
	if trail.size() > 18: trail.pop_front()
	queue_redraw()

func _draw() -> void:
	if rope_index >= 0:
		draw_line(Vector2(0, -6), to_local(anchors[rope_index]), accent.lightened(0.12), 1.5, true)
	if velocity.length() > 430.0:
		for i in range(1, trail.size()):
			var opacity := float(i) / trail.size() * 0.13
			draw_line(to_local(trail[i - 1]), to_local(trail[i]), Color(accent, opacity), 5.0, true)
	var lean := clampf(velocity.x / 1500.0, -0.3, 0.3)
	var bounce := sin(anim) * 1.4 if is_on_floor() and absf(velocity.x) > 20.0 else 0.0
	var cloth := PackedVector2Array([
		Vector2(-6, -6), Vector2(6, -6), Vector2(9 + lean * 12, 10 - visual_squash * 10),
		Vector2(-9 + lean * 12, 10 - visual_squash * 10)])
	draw_colored_polygon(cloth, Color("d8d1bf"))
	draw_line(Vector2(-4, 8), Vector2(-4 + bounce, 16), Color("1e292e"), 3.5, true)
	draw_line(Vector2(4, 8), Vector2(4 - bounce, 16), Color("1e292e"), 3.5, true)
	draw_circle(Vector2(lean * 8, -11 + visual_squash * 10), 5.5, Color("ead9bc"))
	draw_arc(Vector2(lean * 8, -12 + visual_squash * 10), 5.6, PI, TAU, 12, Color("253239"), 3.0, true)
	draw_line(Vector2(-facing * 4, -5), Vector2(-facing * (12 + absf(velocity.x) / 50), -3 + sin(anim) * 2), accent, 3.0, true)
	if charging:
		draw_arc(Vector2.ZERO, 27, -PI / 2, -PI / 2 + TAU * charge / MAX_CHARGE, 40, accent, 2, true)
		var tip := launch_direction(last_axis) * (37 + charge * 25)
		draw_line(Vector2.ZERO, tip, Color(accent, 0.65), 1.0, true)
		draw_circle(tip, 2.5, accent)
	if gliding:
		draw_colored_polygon(PackedVector2Array([Vector2(-32, -19), Vector2(0, -34), Vector2(32, -19), Vector2(0, -24)]), Color(accent, 0.9))
		draw_line(Vector2(-28, -19), Vector2(-6, 0), Color(accent, 0.65), 1.0, true)
		draw_line(Vector2(28, -19), Vector2(6, 0), Color(accent, 0.65), 1.0, true)
