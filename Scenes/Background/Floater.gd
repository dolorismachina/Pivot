extends Sprite

var angle = 0

var start_scale
var end_scale
var rotation_speed
var direction


func _ready():
	randomize()
	start_scale = rand_range(0.1, 1)
	end_scale = rand_range(0.3, 1.5)
	rotation_speed = deg2rad(rand_range(15, 45))
	direction = get_direction()
	
	scale = Vector2(1, 1) * start_scale
	
	$Tween.interpolate_property(self, 'modulate', modulate, Color(1, 1, 1, 0.03), 
		3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
	$Tween.interpolate_property(self, 'scale', scale, scale * end_scale, 
		10, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
	$Tween.start()
	
	
func _process(delta):
	translate(direction * 10 * delta)
	spin(delta)
	
	
func spin(delta):
	rotate(rotation_speed * delta)
	
	
func get_direction():
	randomize()
	var a = rand_range(0, 360)
	
	return Vector2(cos(a), sin(a))
	