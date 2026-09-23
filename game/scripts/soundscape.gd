class_name Soundscape
extends Node

var rain: AudioStreamPlayer
var room: AudioStreamPlayer
var steps: AudioStreamPlayer
var voices: Array[AudioStreamPlayer] = []
var sequence_id := 0
var voice_index := 0
var rain_level := 0.0
signal note_played(index: int)

func _ready() -> void:
	rain = player("rain", -22, true)
	room = player("room", -10, true)
	steps = player("step", -20)
	room.play()
	rain.play()
	for i in range(12):
		var voice := AudioStreamPlayer.new()
		voice.volume_db = -14
		add_child(voice)
		voices.append(voice)

func player(asset: String, volume: float, loop: bool = false) -> AudioStreamPlayer:
	var audio := AudioStreamPlayer.new()
	var stream := load("res://assets/audio/%s.wav" % asset) as AudioStreamWAV
	if loop:
		stream = stream.duplicate()
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		stream.loop_end = int(stream.get_length() * stream.mix_rate)
	audio.stream = stream
	audio.volume_db = volume
	add_child(audio)
	return audio

func _process(delta: float) -> void:
	rain.volume_db = lerpf(rain.volume_db, -22.0 if rain_level > 0 else -70.0, minf(delta * 1.8, 1.0))

func note(index: int, taped: bool = false) -> void:
	var voice := voices[voice_index % voices.size()]
	voice_index += 1
	voice.stream = load("res://assets/audio/note_%d.wav" % clampi(index, 0, 6))
	voice.pitch_scale = 0.993 if taped else 1.0
	voice.volume_db = -17 if taped else -14
	voice.play()
	note_played.emit(index)

func motif() -> void:
	sequence_id += 1
	var token := sequence_id
	var melody := [0, 2, 4, 3, 2, 0, 1, 0]
	for i in range(melody.size()):
		if token != sequence_id:
			return
		note(melody[i], true)
		await get_tree().create_timer(0.48 if i != 5 else 0.85).timeout

func hush() -> void:
	sequence_id += 1
	rain_level = 0
	for voice in voices:
		voice.stop()

func step() -> void:
	steps.pitch_scale = randf_range(0.85, 1.1)
	steps.play()

func shutdown() -> void:
	sequence_id += 1
	for child in get_children():
		if child is AudioStreamPlayer:
			child.stop()
			child.stream = null
