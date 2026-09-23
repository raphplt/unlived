class_name MuseumInterface
extends CanvasLayer

signal action(id: String)
signal volume_changed(value: float)
signal sensitivity_changed(value: float)
signal motion_changed(value: bool)
var root: Control
var screen: Control
var hud: Control
var location_label: Label
var objective: Label
var prompt: Label
var crosshair: Label
var toast_label: Label
var toast_tween: Tween
var fade: ColorRect
var current := ""
var volume := 75.0
var sensitivity := 50.0
var reduced_motion := false
var piano_buttons: Array[Button] = []
var serif: Font = preload("res://assets/fonts/Cormorant.ttf")
var sans: Font = preload("res://assets/fonts/Inter.ttf")
const INK := Color("ebdfc4")
const MUTED := Color("b3b7a4")
const GOLD := Color("d5b781")
const ITEM_DATA := {
	"cassette": {"title": "Cassette", "body": "Au crayon, sur l’étiquette :\n\n« Pour les jours de pluie. »\n\nDimanche / prise 04.", "art": "cassette"},
	"photo": {"title": "Photographie", "body": "Au dos :\n\n« Un dimanche. Avant que le train reparte. »", "art": "photograph"},
	"letter": {"title": "Lettre", "body": "« Il pleut encore ici. J’ai presque terminé le morceau que je t’avais promis.\n\nTu pourrais venir l’écouter. Le piano sonne un peu faux, mais il y a de la place pour deux.\n\nCette fois, je… »", "art": "letter"}
}

func _ready() -> void:
	root = Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)
	var theme := Theme.new()
	theme.default_font = sans
	theme.default_font_size = 16
	root.theme = theme
	var vignette := ColorRect.new()
	vignette.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vignette.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var material := ShaderMaterial.new()
	material.shader = preload("res://shaders/atmosphere.gdshader")
	vignette.material = material
	root.add_child(vignette)
	hud = Control.new()
	hud.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(hud)
	# Quiet scrims keep text readable against both a pale museum and the dark void.
	var hud_gradient := Gradient.new()
	hud_gradient.set_color(0, Color(0.02, 0.04, 0.03, 0.52))
	hud_gradient.set_color(1, Color(0.02, 0.04, 0.03, 0.62))
	hud_gradient.add_point(0.2, Color(0.02, 0.04, 0.03, 0.0))
	hud_gradient.add_point(0.69, Color(0.02, 0.04, 0.03, 0.0))
	var hud_texture := GradientTexture2D.new()
	hud_texture.gradient = hud_gradient
	hud_texture.fill_from = Vector2(0, 0)
	hud_texture.fill_to = Vector2(0, 1)
	var scrim := TextureRect.new()
	scrim.texture = hud_texture
	scrim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scrim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	hud.add_child(scrim)
	location_label = label(hud, "", 15, GOLD)
	location_label.position = Vector2(46, 35)
	objective = label(hud, "", 19, INK, true)
	objective.position = Vector2(46, 64)
	var escape := label(hud, "ÉCHAP   Pause", 13, MUTED)
	anchored(escape, Control.PRESET_TOP_RIGHT, Rect2(-153, 39, 130, 24))
	crosshair = label(hud, "·", 28, INK)
	anchored(crosshair, Control.PRESET_CENTER, Rect2(-4, -20, 8, 40))
	prompt = label(hud, "", 17, INK)
	anchored(prompt, Control.PRESET_CENTER_BOTTOM, Rect2(-300, -105, 600, 36))
	prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	toast_label = label(hud, "", 24, INK, true)
	anchored(toast_label, Control.PRESET_CENTER_BOTTOM, Rect2(-450, -167, 900, 40))
	toast_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var commands := label(hud, "ZQSD / WASD / FLÈCHES   Se déplacer     ·     SOURIS   Regarder     ·     E   Interagir", 12, MUTED)
	anchored(commands, Control.PRESET_CENTER_BOTTOM, Rect2(-450, -42, 900, 24))
	commands.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen = Control.new()
	screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(screen)
	fade = ColorRect.new()
	fade.color = Color("13221e")
	fade.modulate.a = 0
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(fade)

func label(parent: Node, text: String, size: int = 16, color: Color = INK, elegant: bool = false) -> Label:
	var result := Label.new()
	result.text = text
	result.add_theme_font_override("font", serif if elegant else sans)
	result.add_theme_font_size_override("font_size", size)
	result.add_theme_color_override("font_color", color)
	parent.add_child(result)
	return result

func anchored(control: Control, preset: int, rect: Rect2) -> void:
	control.set_anchors_and_offsets_preset(preset)
	control.offset_left = rect.position.x
	control.offset_top = rect.position.y
	control.offset_right = rect.end.x
	control.offset_bottom = rect.end.y

func paragraph(parent: Node, text: String, size: int = 17, color: Color = MUTED) -> Label:
	var result := label(parent, text, size, color)
	result.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	result.add_theme_constant_override("line_spacing", 6)
	return result

func space(parent: Node, height: float) -> void:
	var spacer := Control.new()
	spacer.custom_minimum_size.y = height
	parent.add_child(spacer)

func button(parent: Node, text: String, id: String, primary: bool = false) -> Button:
	var result := Button.new()
	result.text = text
	result.custom_minimum_size.y = 51
	result.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	result.alignment = HORIZONTAL_ALIGNMENT_LEFT
	result.add_theme_font_override("font", serif)
	result.add_theme_font_size_override("font_size", 29)
	result.add_theme_color_override("font_color", GOLD if primary else INK)
	result.add_theme_color_override("font_hover_color", GOLD)
	result.add_theme_color_override("font_focus_color", GOLD)
	for state in ["normal", "hover", "pressed", "focus"]:
		var style := StyleBoxFlat.new()
		style.bg_color = Color.TRANSPARENT
		style.border_color = Color(GOLD, 0.65)
		style.border_width_bottom = 1 if state in ["focus", "hover"] else 0
		style.content_margin_left = 0
		style.content_margin_right = 12
		result.add_theme_stylebox_override(state, style)
	result.pressed.connect(func(): action.emit(id))
	parent.add_child(result)
	return result

func clear(id: String) -> void:
	current = id
	piano_buttons.clear()
	for child in screen.get_children():
		screen.remove_child(child)
		child.queue_free()
	screen.visible = not id.is_empty()
	hud.visible = id.is_empty()

func backdrop(opacity: float = 0.82) -> void:
	var color := ColorRect.new()
	color.color = Color(0.035, 0.072, 0.06, opacity)
	color.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen.add_child(color)

func column(width: float = 490, height: float = 660) -> VBoxContainer:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	screen.add_child(box)
	anchored(box, Control.PRESET_CENTER, Rect2(-width / 2, -height / 2, width, height))
	return box

func menu() -> void:
	clear("menu")
	var gradient := Gradient.new()
	gradient.set_color(0, Color(0.035, 0.075, 0.06, 0.98))
	gradient.set_color(1, Color(0.035, 0.075, 0.06, 0.0))
	gradient.add_point(0.42, Color(0.035, 0.075, 0.06, 0.86))
	var texture := GradientTexture2D.new()
	texture.gradient = gradient
	texture.fill_from = Vector2(0, 0)
	texture.fill_to = Vector2(0.83, 0)
	var veil := TextureRect.new()
	veil.texture = texture
	veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen.add_child(veil)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 14)
	screen.add_child(col)
	anchored(col, Control.PRESET_CENTER_LEFT, Rect2(100, -215, 350, 430))
	label(col, "Unlived", 88, INK, true)
	space(col, 45)
	button(col, "Entrer", "start", true).grab_focus()
	button(col, "Réglages", "settings")
	button(col, "Quitter", "quit")
	var footer := label(screen, "F11   Plein écran", 12, MUTED)
	anchored(footer, Control.PRESET_BOTTOM_LEFT, Rect2(100, -45, 300, 25))

func inspection(id: String, can_keep: bool, returned: bool = false) -> void:
	clear("inspection")
	backdrop(0.88)
	var data: Dictionary = ITEM_DATA[id]
	var layout := HBoxContainer.new()
	layout.add_theme_constant_override("separation", 66)
	screen.add_child(layout)
	anchored(layout, Control.PRESET_CENTER, Rect2(-530, -310, 1060, 620))
	var left := VBoxContainer.new()
	left.custom_minimum_size.x = 420
	layout.add_child(left)
	space(left, 42)
	var art := TextureRect.new()
	art.texture = load("res://assets/art/%s.png" % data.art)
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	art.custom_minimum_size = Vector2(420, 425)
	left.add_child(art)
	space(left, 20)
	var right := VBoxContainer.new()
	right.custom_minimum_size.x = 570
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.add_theme_constant_override("separation", 12)
	layout.add_child(right)
	label(right, data.title, 40, INK, true)
	space(right, 9)
	paragraph(right, data.body, 18, INK)
	space(right, 12)
	if id == "cassette":
		button(right, "▷   Écouter la cassette", "listen")
	if can_keep:
		button(right, "Emporter", "choose:" + id, true)
	if returned:
		button(right, "Recommencer", "restart")
	button(right, "Revenir" if returned else "Reposer", "close").grab_focus()

func confirmation(id: String) -> void:
	clear("confirm")
	backdrop(0.92)
	var col := column(590, 440)
	label(col, "Emporter cet objet ?" if id != "leave" else "Partir ?", 58, INK, true)
	space(col, 14)
	paragraph(col, "Vous ne pourrez plus revenir dans cette pièce.", 18, MUTED)
	space(col, 22)
	button(col, "Emporter" if id != "leave" else "Partir", "commit:" + id, true)
	button(col, "Reposer" if id != "leave" else "Rester", "cancel").grab_focus()

func piano() -> void:
	clear("piano")
	backdrop(0.68)
	var col := column(840, 430)
	label(col, "Pour les jours de pluie", 68, INK, true)
	space(col, 30)
	var keys := HBoxContainer.new()
	keys.add_theme_constant_override("separation", 8)
	col.add_child(keys)
	var names := ["Do", "Ré", "Mi", "Fa", "Sol", "La", "Si"]
	for i in range(7):
		var key := button(keys, "%s\n\n%d" % [names[i], i + 1], "note:" + str(i), true)
		key.custom_minimum_size = Vector2(111, 140)
		key.focus_mode = Control.FOCUS_ALL
		key.alignment = HORIZONTAL_ALIGNMENT_CENTER
		key.add_theme_font_size_override("font_size", 22)
		for state in ["normal", "hover", "pressed", "focus"]:
			var ivory := key.get_theme_stylebox(state).duplicate() as StyleBoxFlat
			ivory.bg_color = INK if state == "normal" else GOLD
			ivory.content_margin_left = 12
			ivory.border_width_bottom = 5
			ivory.border_color = Color("a69779")
			key.add_theme_stylebox_override(state, ivory)
		for state in ["font_color", "font_hover_color", "font_focus_color", "font_pressed_color"]:
			key.add_theme_color_override(state, Color("23382f"))
		piano_buttons.append(key)
	space(col, 20)
	button(col, "▷   Écouter le motif de la cassette", "listen")
	button(col, "Se relever", "close").grab_focus()
	paragraph(col, "Touches 1 à 7 ou clic     ·     Échap pour se relever", 12)

func illuminate_key(index: int) -> void:
	if current != "piano" or piano_buttons.size() != 7: return
	var key := piano_buttons[index]
	key.modulate = Color("dbb36c")
	var tween := key.create_tween()
	tween.tween_property(key, "modulate", Color.WHITE, 0.45)

func pause_menu(from_menu: bool = false) -> void:
	clear("pause")
	backdrop()
	var col := column(510, 740)
	label(col, "Réglages" if from_menu else "Pause", 64, INK, true)
	button(col, "Retour" if from_menu else "Reprendre", "close", true).grab_focus()
	space(col, 13)
	label(col, "Volume", 14, MUTED)
	var slider := HSlider.new()
	slider.min_value = 0
	slider.max_value = 100
	slider.value = volume
	slider.custom_minimum_size.y = 28
	slider.value_changed.connect(func(value): volume = value; volume_changed.emit(value))
	col.add_child(slider)
	label(col, "Sensibilité de la souris", 14, MUTED)
	var mouse_slider := HSlider.new()
	mouse_slider.min_value = 10
	mouse_slider.max_value = 100
	mouse_slider.value = sensitivity
	mouse_slider.custom_minimum_size.y = 28
	mouse_slider.value_changed.connect(func(value): sensitivity = value; sensitivity_changed.emit(value))
	col.add_child(mouse_slider)
	var motion := CheckButton.new()
	motion.text = "Réduire les transitions"
	motion.button_pressed = reduced_motion
	motion.toggled.connect(func(value): reduced_motion = value; motion_changed.emit(value))
	col.add_child(motion)
	button(col, "Plein écran / fenêtre   ·   F11", "fullscreen")
	space(col, 10)
	paragraph(col, "ZQSD / WASD ou flèches : marcher\nSouris : regarder · E : interagir\nÉchap : retour / pause · F11 : plein écran\n\nLa visite n’est pas sauvegardée.", 14)
	space(col, 8)
	if not from_menu:
		button(col, "Recommencer…", "restart")
		button(col, "Quitter…", "ask_quit")

func simple_dialog(id: String, title: String, body: String, confirm: String, command: String) -> void:
	clear(id)
	backdrop(0.9)
	var col := column(540, 380)
	label(col, title, 64, INK, true)
	paragraph(col, body, 18, INK)
	space(col, 24)
	button(col, confirm, command, true)
	button(col, "Annuler", "close").grab_focus()

func empty_trace() -> void:
	clear("trace")
	backdrop(0.12)
	var col := column(280, 150)
	anchored(col, Control.PRESET_CENTER_BOTTOM, Rect2(-140, -180, 280, 150))
	button(col, "Revenir", "close").grab_focus()
	button(col, "Recommencer", "restart")

func set_location(title: String, subtitle: String) -> void:
	location_label.text = title
	objective.text = subtitle
	location_label.visible = not title.is_empty()
	objective.visible = not subtitle.is_empty()

func set_prompt(text: String) -> void:
	prompt.text = "[ E ]    " + text if not text.is_empty() else ""
	crosshair.modulate = GOLD if not text.is_empty() else INK

func toast(text: String) -> void:
	if toast_tween and toast_tween.is_valid(): toast_tween.kill()
	toast_label.text = text
	toast_label.modulate.a = 1
	toast_tween = create_tween()
	toast_tween.tween_interval(5)
	toast_tween.tween_property(toast_label, "modulate:a", 0.0, 1.0)
