extends Node
## End-to-end scene checks; exercised in Godot, including real ray casts.

var failures: Array[String] = []
var count := 0

func check(condition: bool, description: String) -> void:
	count += 1
	if not condition:
		failures.append(description)
		push_error("FAIL: " + description)

func run(game: Node) -> void:
	# All three A endings must retain exactly one object and remove collisions.
	for id in Journey.ITEMS:
		game.journey.variant = Journey.Variant.KEEP
		await game.start_visit()
		check(game.journey.phase == Journey.Phase.HALL, "start in hall")
		check(game.journey.kept.is_empty(), "restart clears kept item")
		check(game.museum.loss == 0, "restart restores room")
		game.visitor.place(Vector3(0, 0.03, -2.8))
		await get_tree().physics_frame
		await get_tree().physics_frame
		check(game.visitor.target() == "enter", "hall portal raycast")
		await game.enter_apartment()
		check(game.journey.phase == Journey.Phase.APARTMENT, "enter apartment")
		if id == "cassette":
			# Sightlines use the same ray and solid geometry as a real visitor.
			var targets := {
				"cassette": [Vector3(27.85, 0.03, -1.3), Vector3(27.85, 1.54, -3.45)],
				"piano": [Vector3(27.2, 0.03, -1.0), Vector3(27.2, 0.95, -2.8)],
				"photo": [Vector3(30.6, 0.03, 1.25), Vector3(31.45, 0.83, -0.53)],
				"letter": [Vector3(27.1, 0.03, 0.9), Vector3(26.45, 0.95, 2.26)]
			}
			for target_id in targets:
				game.visitor.place(targets[target_id][0])
				game.visitor.camera.look_at(targets[target_id][1])
				await get_tree().physics_frame
				await get_tree().physics_frame
				check(game.visitor.target() == target_id, "reachable " + target_id)
			game.visitor.place(Vector3(30, 0.03, 3.0))
			game.visitor.enabled = true
			var key := InputEventKey.new()
			key.physical_keycode = KEY_W
			key.pressed = true
			Input.parse_input_event(key.duplicate())
			for frame in range(30): await get_tree().physics_frame
			key.pressed = false
			Input.parse_input_event(key.duplicate())
			check(game.visitor.position.z < 2.6, "keyboard moves visitor")
			game.lock_player()
			game.ui.pause_menu()
			var paused_position: Vector3 = game.visitor.position
			key.pressed = true
			Input.parse_input_event(key.duplicate())
			for frame in range(10): await get_tree().physics_frame
			key.pressed = false
			Input.parse_input_event(key.duplicate())
			check(game.visitor.position.distance_to(paused_position) < 0.02, "pause stops movement")
			game.close_ui()
		game.interact(id)
		check(game.ui.current == "inspection", "inspection opens")
		check(game.journey.kept.is_empty(), "inspection never commits")
		game.on_action("choose:" + id)
		check(game.ui.current == "confirm", "choice asks confirmation")
		game.on_action("cancel")
		check(game.journey.phase == Journey.Phase.APARTMENT, "cancel preserves life")
		game.close_ui()
		game.play_note(2)
		check(game.journey.notes_played == 1, "piano remains playable")
		await game.commit(id)
		check(game.journey.kept == id, "keeps " + id)
		check(is_instance_valid(game.carried), "chosen item remains visible in hand")
		check(game.museum.loss == 1.0, "apartment erases")
		check(not game.museum.furnishings.visible, "furniture disappears")
		for body in game.museum.furnishings.find_children("*", "StaticBody3D", true, false):
			check(body.collision_layer == 0, "no invisible furniture collision")
		check(not game.journey.commit("photo"), "cannot commit twice")
		game.visitor.place(Vector3(30, 0.03, 2.5), PI)
		await get_tree().physics_frame
		await get_tree().physics_frame
		check(game.visitor.target() == "exit", "exit remains reachable after erasure")
		await game.return_to_hall()
		check(game.journey.phase == Journey.Phase.RETURNED, "returns to hall")
		check(game.museum.keepsake.get_child_count() == 1, "one displayed keepsake")
		check(not is_instance_valid(game.carried), "item placed on plinth")
		game.interact("plinth")
		check(game.ui.current == "inspection", "trace remains inspectable")
		check(not game.journey.enter(), "closed exposition cannot reopen")
	# D closes the passage without destroying the shared apartment.
	game.journey.variant = Journey.Variant.LEAVE
	await game.start_visit()
	await game.enter_apartment()
	for id in Journey.ITEMS:
		game.interact(id)
		check(game.ui.current == "inspection", "D permits all inspections")
		game.close_ui()
	game.interact("exit")
	check(game.ui.current == "confirm", "D departure requires confirmation")
	game.on_action("cancel")
	check(game.journey.phase == Journey.Phase.APARTMENT, "D cancel preserves apartment")
	check(not game.journey.commit("cassette"), "D rejects carrying an object")
	await game.commit("leave")
	check(game.journey.phase == Journey.Phase.RETURNED, "D returns to hall")
	check(game.journey.kept.is_empty(), "D takes no object")
	check(game.museum.loss == 0, "D never erases scene")
	check(game.museum.furnishings.visible, "D apartment remains visible")
	check(game.museum.shutter.visible, "D glass closes")
	check(game.museum.keepsake.get_child_count() == 0, "D plinth remains empty")
	check(game.museum.trace_light.light_energy > 0, "D leaves a light")
	game.interact("plinth")
	check(game.ui.current == "trace", "D trace can be examined")
	game.on_action("restart")
	check(game.ui.current == "restart", "restart must be confirmed")
	game.on_action("reset")
	check(game.ui.current == "menu", "restart allows variant selection")
	await game.start_visit()
	check(game.journey.inspected.is_empty(), "restart clears inspected list")
	check(game.journey.notes_played == 0, "restart clears music history")
	game.sound.shutdown()
	# Let the audio thread release its stream playbacks before process teardown.
	await get_tree().create_timer(0.15).timeout
	await get_tree().process_frame
	await get_tree().process_frame
	print("SMOKE: %d checks, %d failures" % [count, failures.size()])
	for failure in failures:
		print("  FAIL: " + failure)
	get_tree().quit(0 if failures.is_empty() else 1)
