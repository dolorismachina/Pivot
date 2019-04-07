extends Sprite

var angle = 0

func _ready():
	randomize()
	var rnd  = rand_range(0.25, 0.5)
	scale = scale * rnd
	
func _process(delta):
	transform = transform.translated(Vector2(100, 0) * delta)