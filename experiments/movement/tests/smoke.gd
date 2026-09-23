extends Node
## Real physics integration tests. Test inputs use the same per-tick control
## path as keyboard/gamepad; no direct completion or position-based wins.
var lab: Node2D
var player: CharacterBody2D
var failures: Array[String] = []
var count := 0

func check(condition: bool, description: String) -> void:
	count += 1
	if not condition:
		failures.append(description)
		print("FAIL: ", description)

func tick(frames: int, axis := Vector2.ZERO, jump := false, action := false) -> void:
	player.test_axis = axis
	player.test_jump = jump
	player.test_action = action
	for i in frames: await get_tree().physics_frame

func setup(mode: int, room := 0) -> void:
	lab.load_course(mode, room)
	player = lab.mover
	player.controlled_by_test = true
	await tick(5)

func run(game: Node2D) -> void:
	lab = game
	player = lab.mover
	player.controlled_by_test = true
	await setup(0)
	check(player.is_on_floor(), "spawn settles on drawn platform")
	var initial_x: float = player.position.x
	await tick(30, Vector2.RIGHT)
	check(player.position.x > initial_x + 40, "horizontal movement")
	await tick(1, Vector2.ZERO, true)
	await tick(12, Vector2.ZERO, true)
	check(player.position.y < 535, "standard jump leaves ground")
	await tick(70)
	await setup(0)
	await tick(60, Vector2(1, -1).normalized(), false, true)
	check(player.charging and player.charge > 0.45, "charge holds on support")
	check(absf(player.position.x - 110) < 1, "charging does not slide")
	await tick(2, Vector2(1, -1).normalized())
	check(player.velocity.x > 600 and player.velocity.y < -600, "release launches diagonally")
	await tick(8, Vector2.RIGHT, false, true)
	check(not player.charging, "cannot charge without support")
	await setup(0)
	await tick(30, Vector2.RIGHT, false, true)
	await tick(1, Vector2.ZERO, true, true)
	check(not player.charging and absf(player.velocity.x) < 50, "jump cancels prepared launch")
	await setup(0, 1)
	player.reset_at(Vector2(487, 550))
	await tick(8, Vector2.RIGHT)
	await tick(30, Vector2(-1, -1).normalized(), false, true)
	check(player.charging and player.support.x < -0.9, "wall supports a prepared launch")
	var held_y: float = player.position.y
	await tick(12, Vector2(-1, -1).normalized(), false, true)
	check(absf(player.position.y - held_y) < 0.1, "wall grip does not drift")
	await tick(2, Vector2(-1, -1).normalized())
	check(player.velocity.x < -500 and player.velocity.y < -500, "wall release leaves the supporting face")
	await setup(1)
	check(player.nearest_anchor() == -1, "unreachable anchor is not selectable")
	await tick(62, Vector2.RIGHT)
	await tick(1, Vector2.RIGHT, true)
	await tick(12, Vector2.RIGHT, true, true)
	check(player.rope_index == 0, "reachable anchor attaches")
	await tick(55, Vector2.RIGHT, false, true)
	if player.rope_index >= 0:
		check(player.position.distance_to(player.anchors[0]) <= player.rope_length + 1, "rope length stays bounded")
	var before_release: Vector2 = player.velocity
	await tick(1, Vector2.RIGHT)
	check(player.rope_index == -1, "release detaches rope")
	check(player.velocity.x >= before_release.x - 30, "release preserves horizontal momentum")
	await setup(1, 2)
	player.reset_at(Vector2(650, 300))
	await tick(1)
	check(not player.line_clear(Vector2(800, 235)), "wall blocks rope targeting")
	check(player.nearest_anchor() != 1, "occluded anchor cannot be selected")
	await setup(2)
	await tick(1, Vector2.RIGHT, true)
	await tick(18, Vector2.RIGHT, true, true)
	check(player.gliding, "airborne ability opens sail")
	await tick(70, Vector2.RIGHT, false, true)
	check(player.velocity.y <= 91, "gliding caps fall speed")
	await tick(20, Vector2.RIGHT)
	check(not player.gliding and player.velocity.y > 150, "closing sail restores fall")
	await setup(2, 1)
	# Place above the first current to test the force independently of routing.
	player.reset_at(Vector2(425, 450))
	await tick(45, Vector2.ZERO, false, true)
	check(player.position.y < 395 and player.velocity.y < -200, "current lifts an open sail")
	lab.set_paused(true)
	var paused_position: Vector2 = player.position
	var paused_time: float = lab.timer
	await tick(40, Vector2.RIGHT, true, true)
	check(player.position.distance_to(paused_position) < 0.01, "pause freezes movement")
	check(is_equal_approx(lab.timer, paused_time), "pause freezes timer")
	lab.set_paused(false)
	await setup(0)
	player.position.y = 850
	await tick(5)
	check(lab.deaths == 1 and player.position.y < 600, "fall automatically returns to start")
	lab.retry(true)
	check(lab.deaths == 0 and lab.timer == 0 and not lab.started, "restart clears attempt")
	# Verify actual InputMap events, not only the deterministic driver.
	player.controlled_by_test = false
	var key := InputEventKey.new()
	key.physical_keycode = KEY_D
	key.pressed = true
	Input.parse_input_event(key)
	for frame in 30: await get_tree().physics_frame
	check(player.position.x > 150, "physical D reaches the movement InputMap")
	key = InputEventKey.new()
	key.physical_keycode = KEY_D
	Input.parse_input_event(key)
	for frame in 12: await get_tree().physics_frame
	check(absf(player.velocity.x) < 1, "key release stops on the ground")
	player.controlled_by_test = true
	# Prove complete routes, with real collision and goal detection, in all rooms.
	for room in 3:
		await route_appui(room)
	for room in 3:
		await route_sail(room)
	for room in 3:
		await route_rope(room)
	print("MOVEMENT: %d checks, %d failures" % [count, failures.size()])
	get_tree().quit(0 if failures.is_empty() else 1)

func route_appui(room: int) -> void:
	await setup(0, room)
	var platforms: Array = lab.level.solids.slice(0, 3 if room < 2 else 4)
	for i in range(1, platforms.size()):
		var target: Rect2 = platforms[i]
		if room == 2 and i == 3:
			# Reposition on the left of the narrow ledge to clear the next
			# platform's front face, rather than jumping into its side.
			for step in 90:
				if player.position.x <= 795: break
				await tick(1, Vector2.LEFT)
			await tick(12)
		# Use a keyboard diagonal and vary the charge. The route is playable
		# without an analogue controller; aim selection below stays at 45°.
		var dx: float = target.get_center().x - player.position.x
		var rise: float = player.position.y + 16 - target.position.y
		var best_error := INF
		var best_axis := Vector2(1, -1).normalized()
		var best_frames := 60
		for frames in range(1, 61):
			var speed := lerpf(570, 1030, minf(1, frames / 60.0))
			for degrees in [45]:
				var direction := Vector2(cos(deg_to_rad(degrees)), -sin(deg_to_rad(degrees)))
				direction.y = minf(-0.65, direction.y)
				direction = direction.normalized()
				var vy := -direction.y * speed
				var discriminant := vy * vy - 3000 * rise
				if discriminant < 0: continue
				var flight := (vy + sqrt(discriminant)) / 1500.0
				# Reject trajectories crossing the low ceiling in course 3.
				var blocked := false
				if room == 2:
					for sample_index in range(1, 31):
						var t := flight * sample_index / 30.0
						var point := player.position + Vector2(direction.x * speed * t, -vy * t + 750.0 * t * t)
						if Rect2(625, 249, 295, 60).has_point(point): blocked = true
				if blocked: continue
				var error := absf(direction.x * speed * flight - dx)
				if error < best_error:
					best_error = error
					best_axis = direction
					best_frames = frames
		await tick(best_frames, best_axis, false, true)
		await tick(2, best_axis)
		for frame in 210:
			await tick(1)
			if player.is_on_floor() or lab.deaths > 0: break
		print("APPUI route ", room, " ledge ", i, " pos ", player.position, " falls ", lab.deaths)
		if lab.deaths > 0: break
		await tick(10)
	for frame in 240:
		await tick(1, Vector2.RIGHT)
		if lab.completed or lab.deaths > 0: break
	check(lab.completed and lab.deaths == 0, "Appui route %d can finish" % (room + 1))

func route_sail(room: int) -> void:
	await setup(2, room)
	var jumped := false
	for frame in 1500:
		var jump := not jumped and player.position.x > (255 if room == 2 else 295)
		if jump: jumped = true
		var sail := not player.is_on_floor()
		var axis := Vector2.RIGHT
		# Stay in rising air until the next ledge is reachable, then cross.
		if room > 0:
			var region: Rect2 = lab.level.winds[0 if player.position.x < 760 else 1]
			var next_top := 430.0 if room == 1 and player.position.x < 760 else 270.0
			if room == 2: next_top = 610.0 if player.position.x < 760 else 410.0
			if player.position.x > region.end.x - 100 and player.position.x < region.end.x and player.position.y > next_top - 90:
				axis = Vector2.LEFT if player.velocity.x > 0 else Vector2.RIGHT
			if room == 2 and player.position.x > 475 and player.position.x < 780:
				sail = false
			# A new jump from an intermediate platform starts the next crossing.
			if player.is_on_floor() and player.position.x > 665 and frame % 3 == 0: jump = true
		if player.position.x > 1110:
			axis = Vector2.LEFT if player.velocity.x > 0 else Vector2.RIGHT
			sail = false
		await tick(1, axis, jump, sail)
		if lab.completed or lab.deaths > 0: break
	print("SAIL route ", room, " pos ", player.position, " falls ", lab.deaths)
	check(lab.completed and lab.deaths == 0, "Portance route %d can finish" % (room + 1))

func route_rope(room: int) -> void:
	await setup(1, room)
	var released := -1
	var cooldown := 0
	var jump_frames := 0
	for frame in 1800:
		var standing: Rect2 = lab.level.solids[0]
		for pad: Rect2 in lab.level.solids:
			if player.position.x >= pad.position.x and player.position.x <= pad.end.x and absf(player.position.y + 16 - pad.position.y) < 3:
				standing = pad
		if player.is_on_floor() and player.position.x > standing.end.x - 55 and standing.end.x < 1200:
			jump_frames = 18
		var jump := jump_frames > 0
		if jump_frames > 0: jump_frames -= 1
		var action := false
		if cooldown > 0: cooldown -= 1
		if player.rope_index >= 0:
			action = true
			var anchor: Vector2 = player.anchors[player.rope_index]
			var target: Rect2 = lab.level.solids[player.rope_index + 1]
			if (player.position.x > anchor.x + 80 and player.position.y < target.position.y - 55 and player.velocity.y < -100) or player.is_on_floor():
				released = player.rope_index
				action = false
				cooldown = 3
				jump = false
		elif cooldown == 0 and player.candidate >= 0 and player.candidate != released and not player.is_on_floor() and jump_frames < 5:
			action = true
		var axis := Vector2.RIGHT
		if player.position.x > 1180: axis = Vector2.LEFT
		await tick(1, axis, jump, action)
		if lab.completed or lab.deaths > 0: break
	print("ROPE route ", room, " pos ", player.position, " falls ", lab.deaths)
	check(lab.completed and lab.deaths == 0, "Balancier route %d can finish" % (room + 1))
