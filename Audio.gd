extends Node


export (Array) var samples : Array
var current_sample_index = 0


var audio_path = 'res://Scenes/Player/'


func _ready():
	randomize()
	
	samples.append(load(audio_path + 'Jump_4.wav'))
	samples.append(load(audio_path + 'Jump_5.wav'))
	samples.append(load(audio_path + 'Jump_6.wav'))

	

func play():
	var p : AudioStreamPlayer = AudioStreamPlayer.new()
	p.volume_db = -18
	add_child(p)
	p.stream = next_sample()
	p.play()
	p.connect("finished", self, "stream_finished", [p])
	

func next_sample() -> AudioStreamSample:
	randomize()
	var rnd : int = 0
	if current_sample_index == 0:
		rnd = floor(rand_range(0, 2))
	if current_sample_index == samples.size() - 1:
		rnd = floor(rand_range(-1, 1))
	if current_sample_index > 0 and current_sample_index < samples.size() - 1:
		rnd = floor(rand_range(-1, 2))
		
	current_sample_index += rnd
	return samples[current_sample_index]
	

func stream_finished(p : AudioStreamPlayer):
	p.queue_free()
