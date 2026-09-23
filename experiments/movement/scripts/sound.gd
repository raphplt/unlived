extends Node
## Quiet procedural feedback, not a musical or artistic direction for Unlived.
var enabled := true
var voices: Array[AudioStreamPlayer] = []
var samples: Dictionary = {}
var cursor := 0

func _ready() -> void:
	for i in 6:
		var voice := AudioStreamPlayer.new()
		voice.volume_db = -18.0
		add_child(voice)
		voices.append(voice)
	for kind in ["jump", "launch", "land", "catch", "release", "open", "finish", "retry"]:
		samples[kind] = sample(kind)

func play(kind: String) -> void:
	if not enabled or not samples.has(kind): return
	var voice := voices[cursor % voices.size()]
	cursor += 1
	voice.stream = samples[kind]
	voice.play()

func sample(kind: String) -> AudioStreamWAV:
	var duration := 0.13
	var frequency := 240.0
	match kind:
		"launch": frequency = 340.0; duration = 0.20
		"land": frequency = 95.0; duration = 0.085
		"catch": frequency = 680.0; duration = 0.14
		"release": frequency = 410.0; duration = 0.11
		"open": frequency = 170.0; duration = 0.25
		"finish": frequency = 520.0; duration = 0.65
		"retry": frequency = 130.0; duration = 0.16
	var rng := RandomNumberGenerator.new()
	rng.seed = 23
	var bytes := PackedByteArray()
	bytes.resize(int(duration * 22050) * 2)
	for i in bytes.size() / 2:
		var t := float(i) / 22050.0
		var envelope := minf(t * 140.0, 1.0) * pow(1.0 - t / duration, 2.5)
		var value := sin(TAU * frequency * t) * 0.23
		if kind == "finish": value += sin(TAU * frequency * 1.5 * t) * 0.13
		if kind in ["land", "open", "launch"]: value += rng.randf_range(-0.11, 0.11)
		bytes.encode_s16(i * 2, int(clampf(value * envelope, -1.0, 1.0) * 32767))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = 22050
	stream.data = bytes
	return stream
