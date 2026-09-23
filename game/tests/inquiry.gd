extends Node
## Integration checks use actual collision geometry, input dispatch and saved pixels.
## They establish technical behavior, not that the investigation is enjoyable.
var count := 0
var failures: Array[String] = []
var temporary_directories: Array[String] = []

func check(condition: bool, description: String) -> void:
	count += 1
	if not condition:
		failures.append(description)
		push_error("FAIL: " + description)

func temporary_directory(label: String) -> String:
	var path := "user://pieces-manquantes-tests/%s-%d" % [label, Time.get_ticks_usec()]
	temporary_directories.append(path)
	return path

func key(code: Key, pressed: bool) -> void:
	var event := InputEventKey.new()
	event.keycode = code
	event.physical_keycode = code
	event.pressed = pressed
	Input.parse_input_event(event)

func tap(code: Key) -> void:
	key(code, true)
	await get_tree().process_frame
	key(code, false)
	await get_tree().physics_frame
	await get_tree().physics_frame

func press_button(game: Node, words: String) -> bool:
	for button in game.ui.overlay.find_children("*", "Button", true, false):
		if button.text == words:
			button.pressed.emit()
			return true
	return false

func walk_to(game: Node, destination: Vector3, frame_limit: int = 360) -> bool:
	game.visitor.enabled = true
	key(KEY_W, true)
	var reached := false
	for frame in range(frame_limit):
		var delta: Vector3 = destination - game.visitor.position
		delta.y = 0
		if delta.length() < 0.35:
			reached = true
			break
		game.visitor.rotation.y = atan2(-delta.x, -delta.z)
		await get_tree().physics_frame
	key(KEY_W, false)
	game.visitor.velocity = Vector3.ZERO
	return reached

func check_archive() -> void:
	var archive := InquiryArchive.new()
	archive.directory = temporary_directory("archive")
	archive.data.notes = "Revenir à la même fenêtre."
	archive.record("address")
	archive.record("address")
	archive.reserve_object("city", "object_print")
	archive.reserve_object("city", "object_notebook")
	var image := Image.create(4, 4, false, Image.FORMAT_RGBA8)
	for entry in [[Color.RED, "city"], [Color.BLUE, "city"], [Color.GREEN, "greenhouse"]]:
		image.fill(entry[0])
		archive.photograph(image, entry[1])
	archive.reserve_photo(1)
	archive.reserve_photo(2)
	var city_file: String = archive.data.photos[1].file
	var green_file: String = archive.data.photos[2].file
	DirAccess.remove_absolute(ProjectSettings.globalize_path(archive.directory + "/" + archive.data.photos[0].file))
	var restored := InquiryArchive.new()
	restored.directory = archive.directory
	check(restored.restore(), "save remains readable when an unselected photo is missing")
	check(restored.data.objects.city == "object_notebook" and restored.data.notes == archive.data.notes and restored.data.documents == ["address"], "replacement, notes and consulted documents survive reload")
	for entry in [["city", city_file], ["greenhouse", green_file]]:
		var index := int(restored.data.chosen_photos.get(entry[0], -1))
		check(index >= 0 and index < restored.data.photos.size() and restored.data.photos[index].file == entry[1], "missing earlier photo preserves the chosen image in " + entry[0])
	check(restored.texture(0).get_image().get_pixel(0, 0).is_equal_approx(Color.BLUE), "stored photograph retains original pixels")
	check(not restored.reserve_photo(-1) and not restored.reserve_photo(99), "invalid photo selections leave collection intact")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(archive.directory + "/" + city_file))
	restored = InquiryArchive.new()
	restored.directory = archive.directory
	check(restored.restore() and not restored.data.chosen_photos.has("city") and restored.data.chosen_photos.has("greenhouse"), "missing selected photo clears only its own alcove")

func check_geometry(game: Node, graphics: bool) -> void:
	await get_tree().physics_frame
	var foot := InquiryWorld.CITY + Vector3(-4.5, 2.44, -4)
	for id in InquiryWorld.VIEWS:
		var point: Vector3 = InquiryWorld.CITY + InquiryWorld.VIEWS[id]
		var query := PhysicsRayQueryParameters3D.create(point, foot, 1)
		var hit: Dictionary = game.world.get_world_3d().direct_space_state.intersect_ray(query)
		var base_visible: bool = not hit.is_empty() and hit.collider.get_parent() == game.world.tank
		check(base_visible == id.ends_with("high"), "reservoir base visibility matches the height at " + id)
		var forward := Vector3(0, 0, -1 if id.begins_with("south") else 1)
		var right := forward.cross(Vector3.UP)
		var tank_offset: Vector3 = game.world.tank.global_position - game.world.bridge.global_position
		check((tank_offset.dot(right) < 0) == id.begins_with("south"), "reservoir is on the correct side at " + id)
	if graphics: return # Physical input is covered headlessly without desktop focus interference.
	# Simulated time speeds the physical walk up without changing movement rules.
	var old_scale := Engine.time_scale
	Engine.time_scale = 4
	for entry in [{"x": 16.6, "side": 1.0}, {"x": -16.6, "side": -1.0}]:
		var side: float = entry.side
		game.travel("city", InquiryWorld.CITY + Vector3(entry.x, 0.03, -12 * side))
		var top := InquiryWorld.CITY + Vector3(entry.x, 4.2, 14 * side)
		var climbed := await walk_to(game, top)
		check(climbed and game.visitor.position.y > 4.0, "walk up ramp to " + ("south" if side > 0 else "north"))
		var crossed := await walk_to(game, InquiryWorld.CITY + Vector3(0, 4.2, 14 * side))
		check(crossed and game.visitor.position.y > 4.0, "upper room is reachable through the opening from its ramp: side=%s position=%s" % [side, game.visitor.position - InquiryWorld.CITY])
	Engine.time_scale = old_scale

func check_controls_and_restore(game: Node) -> void:
	game.travel("greenhouse", InquiryWorld.GREEN + Vector3(-1.5, 0.03, 4.55))
	game.visitor.camera.look_at(InquiryWorld.GREEN + Vector3(-1.5, 0.8, 6))
	await get_tree().physics_frame
	await get_tree().physics_frame
	check(game.visitor.target() == "sit", "bed is reachable with the real interaction ray")
	await tap(KEY_E)
	check(game.sitting and game.visitor.walk_speed == 0, "E sits without allowing walking")
	# Looking away must never trap a seated player.
	game.visitor.camera.look_at(InquiryWorld.GREEN + Vector3(-9.7, 2, 5.5))
	await tap(KEY_E)
	check(not game.sitting and game.visitor.enabled and is_equal_approx(game.visitor.camera.position.y, 1.64), "E stands even when the bed is no longer targeted")
	game.show_document("object_box")
	check(press_button(game, "Réserver pour l’alcôve"), "object reservation is reachable through its actual UI button")
	check(game.archive.data.objects.get("greenhouse") == "object_box", "box reservation reaches the collection")
	game.show_document("object_box")
	var was_slid: bool = game.world.switches.slide
	check(press_button(game, "Faire glisser le cylindre"), "box manipulation exists in its document UI")
	check(game.world.switches.slide != was_slid and game.ui.current.is_empty(), "reserved box remains manipulable through UI dispatch")
	game.show_document("object_cup")
	press_button(game, "Réserver pour l’alcôve")
	check(game.archive.data.objects.get("greenhouse") == "object_cup", "another object freely replaces the collection choice")
	game.interact("curtain")
	game.interact("lamp")
	check(game.world.projector.visible, "curtain and lamp activate the projector")
	var saved_position := InquiryWorld.GREEN + Vector3(2.2, 0.03, 7.7)
	game.visitor.place(saved_position, 0.7)
	game.visitor.camera.rotation.x = -0.23
	game.lock_player()
	game.on_action("notes")
	game.notes_editor.text = "Une note encore ouverte."
	game.save_visit()
	game.close_ui()
	game.visitor.place(Vector3.ZERO)
	game.world.switches.slide = was_slid
	game.start_visit(true)
	check(game.zone == "greenhouse" and game.visitor.position.is_equal_approx(saved_position) and is_equal_approx(game.visitor.rotation.y, 0.7) and is_equal_approx(game.visitor.camera.rotation.x, -0.23), "resume restores saved pose rather than the room entrance")
	check(game.world.switches.slide != was_slid and game.archive.data.notes == "Une note encore ouverte.", "resume restores manipulations and a note saved while editing")
	for transition in [["green_hall", "hall"], ["to_city", "city"], ["backstage", "backstage"], ["backstage_green", "greenhouse"], ["green_hall", "hall"], ["to_greenhouse", "greenhouse"]]:
		game.interact(transition[0])
		check(game.zone == transition[1], "free return after collection: " + transition[0])

func check_photographs(game: Node) -> void:
	check(game.world.reference_full != null and game.album_photo != null, "evidence images are rendered from the scene")
	game.travel("greenhouse", InquiryWorld.GREEN + Vector3(7, 0.03, 8))
	game.visitor.camera.look_at(InquiryWorld.GREEN + Vector3(-2, 1.5, -4))
	await game.take_photo()
	var first: int = game.photo_index
	game.visitor.camera.look_at(InquiryWorld.GREEN + Vector3(5, 1.2, 5.6))
	await game.take_photo()
	var second: int = game.photo_index
	check(second == first + 1 and game.archive.texture(first).get_image().get_data() != game.archive.texture(second).get_image().get_data(), "different player viewpoints produce different saved photographs")
	game.photo_index = first
	game.notebook()
	press_button(game, "Retenir pour l’alcôve")
	game.photo_index = second
	game.notebook()
	press_button(game, "Retenir pour l’alcôve")
	check(game.archive.data.chosen_photos.get("greenhouse") == second, "notebook replaces a selected player photograph")
	game.close_ui()
	game.interact("green_hall")
	var displayed: Texture2D = game.world.alcoves.greenhouse.image.material_override.albedo_texture
	check(displayed != null and displayed.get_image().get_data() == game.archive.texture(second).get_image().get_data(), "hall displays the exact player-selected photograph")
	game.interact("to_city")
	await game.take_photo()
	game.notebook()
	press_button(game, "Retenir pour l’alcôve")
	check(game.archive.data.chosen_photos.has("city") and game.archive.data.chosen_photos.greenhouse == second, "both alcoves retain independent player photographs")
	game.close_ui()
	game.show_document("object_lou")
	press_button(game, "Réserver pour l’alcôve")
	game.interact("city_hall")
	game.visitor.place(Vector3(0, 0.03, 0))
	game.visitor.camera.look_at(Vector3(0, 2.1, -6))
	await capture_ui("collection")
	game.interact("to_greenhouse")
	check(game.zone == "greenhouse", "filling both photographic alcoves does not end the investigation")
	game.notebook()
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(ProjectSettings.globalize_path("res://../artifacts/inquiry-notebook.png"))

func check_visible_controls(game: Node, description: String) -> void:
	var bounds := get_viewport().get_visible_rect().grow(1)
	var fits := true
	for control in game.ui.overlay.find_children("*", "Control", true, false):
		if control.is_visible_in_tree() and (control is Button or control is TextureRect):
			if not bounds.encloses(control.get_global_rect()): fits = false
	check(fits, description)

func capture_ui(name: String) -> void:
	get_window().grab_focus()
	await get_tree().process_frame
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(ProjectSettings.globalize_path("res://../artifacts/inquiry-" + name + ".png"))

func check_minimum_window(game: Node) -> void:
	game.close_ui()
	get_window().mode = Window.MODE_WINDOWED
	await get_tree().create_timer(0.5).timeout
	get_window().size = Vector2i(960, 600)
	get_window().grab_focus()
	await get_tree().create_timer(0.3).timeout
	check(get_window().size == Vector2i(960, 600), "minimum-window screenshots use an actual 960 by 600 window")
	game.notebook()
	press_button(game, "Comparer")
	await capture_ui("notebook-960")
	check_visible_controls(game, "comparison controls and images fit the minimum window")
	game.close_ui()
	game.interact("enlarger")
	press_button(game, "Écarter les caches")
	await capture_ui("film-960")
	check_visible_controls(game, "enlarger image and controls fit the minimum window")
	game.close_ui()
	await tap(KEY_ESCAPE)
	await capture_ui("pause-960")
	check_visible_controls(game, "pause controls fit the minimum window")
	await tap(KEY_ESCAPE)
	await tap(KEY_F11)
	await get_tree().create_timer(0.4).timeout
	check(get_window().mode == Window.MODE_FULLSCREEN, "F11 enters fullscreen")
	await tap(KEY_F11)
	await get_tree().create_timer(0.4).timeout
	check(get_window().mode == Window.MODE_WINDOWED, "F11 restores the previous window mode")

func run(game: Node, graphics: bool) -> void:
	if graphics:
		get_window().mode = Window.MODE_WINDOWED
		get_window().grab_focus()
		while not game.evidence_ready: await get_tree().process_frame
	game.start_visit()
	game.archive.directory = temporary_directory("visit")
	check(game.zone == "hall", "start in hall")
	for transition in [["to_city", "city"], ["backstage", "backstage"], ["backstage_green", "greenhouse"], ["green_hall", "hall"]]:
		game.interact(transition[0])
		check(game.zone == transition[1] and game.archive.data.documents.is_empty(), "direct discovery without prerequisite documents: " + transition[0])
	check_archive()
	await check_geometry(game, graphics)
	await check_controls_and_restore(game)
	if graphics:
		await check_photographs(game)
		await check_minimum_window(game)
	game.sound.shutdown()
	game.started = false
	game.visitor.enabled = false
	for directory in temporary_directories:
		for filename in DirAccess.get_files_at(directory):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(directory + "/" + filename))
		DirAccess.remove_absolute(ProjectSettings.globalize_path(directory))
	await get_tree().create_timer(0.15).timeout
	print("INQUIRY: %d checks, %d failures" % [count, failures.size()])
	get_tree().quit(0 if failures.is_empty() else 1)
