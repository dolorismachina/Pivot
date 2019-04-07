extends "res://Scenes/Blocks/Block/Block.gd"

class_name FallingBlock


export (int) var max_touches = 2
onready var default_position = position

var numbers_touched = 0

var is_falling : bool = false
var gravity = 1100
var velocity = 0


func _ready():
	._ready()
	
	$Sprite.modulate = Color.red
	
	
func _process(delta):
	if is_falling:
		invert_rotation()
		velocity += gravity * delta
		global_translate(Vector2(0, velocity) * delta)
	
	
# Apply inverse rotation of the whole level to make the block fall down the screen.
func invert_rotation():
	var inv = self.get_parent().get_parent().get_parent().transform.affine_inverse()
	self.rotation = inv.get_rotation()


func fall() -> void:
	print('fallling')
	$Tween.interpolate_property(self, 'global_rotation',
		global_rotation, 0, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
	$Tween.interpolate_property(self, 'modulate',
		modulate, modulate - Color(0, 0, 0, 1), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	
	is_falling = true


func reset():
	numbers_touched = 0
	is_falling = false
	position = default_position
	velocity = 0
	rotation = 0
	
	set_process(false)
	

# Called in reaction to contact with the ball.
func contact() -> void:
	.contact()
	
	set_process(true)
	
	numbers_touched += 1
	if numbers_touched >= max_touches:
		#self.
		fall()
	else:
		$Sprite.modulate.a = 0.5