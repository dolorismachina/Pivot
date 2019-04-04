extends StaticBody2D

class_name Block


export (PoolColorArray) var colors

export (int) var bounce_limit = 500 # Max vertical speed of the ball after bouncing from this block.

export (NodePath) var previous_block_path
export (NodePath) var next_block_path
var next_block : Block setget , get_next
var previous_block : Block

export (bool) var is_visible = false
export (bool) var is_enabled = false


func get_next():
	return get_node(next_block_path)

func _ready():
	set_random_color()
	
	if not is_visible:
		$Sprite.modulate.a = 0
	
	if previous_block_path:
		previous_block = get_node(previous_block_path)
	if next_block_path:
		next_block = get_node(next_block_path)
	
	if is_enabled:
		enable()
	else:
		disable()


func set_random_color():
	randomize()
	var random_number = floor(rand_range(0, colors.size() - 1))
	$Sprite.modulate = colors[random_number]
	
func glow():
	var previous_color = $Sprite.modulate
	$Sprite.modulate += $Sprite.modulate / 2
	
	$GlowTween.interpolate_property($Sprite, 'modulate',
	$GlowTween.modulate, previous_color, 1, 
	Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$GlowTween.start()  


func contact():
	glow()
	$ColliderTimer.start()
	$CollisionShape2D.disabled = true
	
	if previous_block:
		previous_block.fade_out()
		previous_block.disable()
	
	if next_block:
		next_block.fade_in()
		
		next_block.enable()


func fade_out():
	var m1 = get_node('./Sprite').modulate
	var m1_new = Color(m1.r, m1.g, m1.b, 0.05)
	$Tween.interpolate_property($Sprite, 'modulate', m1, m1_new, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	
	# var m2 = previous_block.get_node('./Sprite').modulate
	# var m2_new = Color(m2.r, m2.g, m2.b, 0)
	# $Tween.interpolate_property(previous_block.get_node('./Sprite'), 'modulate', m2, m2_new, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	
	$Tween.start()


func fade_in():
	var m1 = get_node('./Sprite').modulate
	var m1_new = Color(m1.r, m1.g, m1.b, 1)
	$Tween.interpolate_property($Sprite, 'modulate', m1, m1_new, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	
	# var m2 = next_block.get_node('./Sprite').modulate
	# var m2_new = Color(m2.r, m2.g, m2.b, 0.1)
	# $Tween.interpolate_property(next_block.get_node('./Sprite'), 'modulate', m2, m2_new, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN)

	$Tween.start()

func show():
	$Sprite.visible = true
	$Sprite.modulate.a = 1


func enable():
	$CollisionShape2D.disabled = false
	is_enabled = true

func disable():
	disable_collision()
	$Sprite.modulate.a = 0
	is_enabled = false

func disable_collision():
	$CollisionShape2D.disabled = true
	

func _on_ColliderTimer_timeout():
	if is_enabled:
		$CollisionShape2D.disabled = false