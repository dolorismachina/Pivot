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
var sprinkles = preload("res://Scenes/Sprinkles/Sprinkles.tscn")

var block_color = Color()


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
	block_color = colors[random_number]


func glow():
	$Sprite.modulate += Color(0.2, 0.2, 0.2, 0) #$Sprite.modulate / 10

	$GlowTween.interpolate_property($Sprite, 'modulate', $GlowTween.modulate,
		block_color, 0.75, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$GlowTween.start()


func contact():
	glow()
	$ColliderTimer.start()
	$CollisionShape2D.disabled = true

	spawn_particles()


func spawn_particles():
	var particles = sprinkles.instance()
	particles.position.y += 15
	add_child(particles)


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


# Virtual method used by child nodes.
func activate():
	pass


# Virtual method used by child nodes.
func deactivate():
	pass


# Virtual method used by child nodes.
func reset():
	pass
