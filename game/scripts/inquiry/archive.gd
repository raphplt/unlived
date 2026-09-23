class_name InquiryArchive
extends RefCounted
## Versioned, independent save slot. An interrupted write keeps the previous save.
var directory := "user://pieces-manquantes"
var data := {"version": 1, "zone": "hall", "position": [0.0, 0.05, 5.0], "yaw": 0.0, "pitch": 0.0, "photos": [], "documents": [], "objects": {}, "chosen_photos": {}, "notes": "", "states": {}, "places": ["hall"]}
var last_error := ""

func exists() -> bool:
	return FileAccess.file_exists(directory + "/save.json")

func restore() -> bool:
	if not exists(): return false
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(directory + "/save.json"))
	if not parsed is Dictionary or parsed.get("version") != 1:
		last_error = "Sauvegarde illisible."
		return false
	for key in data:
		if parsed.has(key) and typeof(parsed[key]) == typeof(data[key]): data[key] = parsed[key]
	# Missing image files never remove access to rooms or objects.
	var valid: Array = []
	var remap := {}
	var previous := 0
	for photo in data.photos:
		if photo is Dictionary and str(photo.get("file", "")).is_valid_filename() and FileAccess.file_exists(directory + "/" + photo.file):
			remap[previous] = valid.size()
			valid.append(photo)
		previous += 1
	var retained := {}
	for zone in data.chosen_photos:
		var old_index := int(data.chosen_photos[zone])
		if remap.has(old_index) and valid[remap[old_index]].zone == zone:
			retained[zone] = remap[old_index]
	data.chosen_photos = retained
	data.photos = valid
	return true

func save() -> bool:
	last_error = ""
	var error := DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(directory))
	if error != OK:
		last_error = "La sauvegarde n’a pas pu être écrite."
		return false
	var file := FileAccess.open(directory + "/save.tmp", FileAccess.WRITE)
	if file == null:
		last_error = "La sauvegarde n’a pas pu être écrite."
		return false
	file.store_string(JSON.stringify(data))
	file.flush()
	file.close()
	error = DirAccess.rename_absolute(ProjectSettings.globalize_path(directory + "/save.tmp"), ProjectSettings.globalize_path(directory + "/save.json"))
	if error != OK: last_error = "La sauvegarde n’a pas pu être écrite."
	return error == OK

func photograph(image: Image, zone: String) -> int:
	if image == null or image.is_empty(): return -1
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(directory))
	var filename := "photo_%d_%d.png" % [Time.get_unix_time_from_system(), Time.get_ticks_usec()]
	if image.save_png(directory + "/" + filename) != OK:
		last_error = "La photographie n’a pas pu être enregistrée."
		return -1
	data.photos.append({"file": filename, "zone": zone})
	if not save():
		data.photos.pop_back()
		return -1
	return data.photos.size() - 1

func texture(index: int) -> Texture2D:
	if index < 0 or index >= data.photos.size(): return null
	var image := Image.load_from_file(directory + "/" + str(data.photos[index].file))
	return ImageTexture.create_from_image(image) if image != null else null

func reserve_object(zone: String, id: String) -> bool:
	var previous: Variant = data.objects.get(zone)
	data.objects[zone] = id
	if save(): return true
	if previous == null: data.objects.erase(zone)
	else: data.objects[zone] = previous
	return false

func reserve_photo(index: int) -> bool:
	if index < 0 or index >= data.photos.size(): return false
	var photo: Dictionary = data.photos[index]
	if photo.zone not in ["city", "greenhouse"]: return false
	var previous: Variant = data.chosen_photos.get(photo.zone)
	data.chosen_photos[photo.zone] = index
	if save(): return true
	if previous == null: data.chosen_photos.erase(photo.zone)
	else: data.chosen_photos[photo.zone] = previous
	return false

func record(id: String) -> void:
	if id not in data.documents:
		data.documents.append(id)
		save()
