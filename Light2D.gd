tool

extends Light2D

var rate = 0

func _ready():
  randomize()
  
  rate = rand_range(0, 1)

var t = 0
func _process(delta):
  t += delta
  
  energy = abs(sin(t * rate))