extends KinematicBody2D

class_name Player

signal reached_end
signal position_reached

export (int) var bounce_limit = 500
export (float) var horizontal_damping = 0.985

var velocity = Vector2(0, 0)
var initial_gravity = Vector2(0, 950)
var gravity = Vector2(0, 0)
var next_block : Block
var last_block : Block


var acc = Vector2(5, 0)
func _process(delta : float):
	velocity += gravity * delta
	velocity.y = clamp(velocity.y, -bounce_limit, bounce_limit)
	velocity.x *= horizontal_damping
	
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)
	
	if collision:
		print(collision.collider.name)
		collide(collision)
			
		$Audio.play()
		#$AnimationPlayer.play("bounce")
		velocity = velocity.normalized().bounce(collision.normal) * bounce_limit

func _unhandled_input(event):
		
	if event.is_action_pressed("ui_left"):
		velocity += Vector2(-100, 0)
				
	if event.is_action_pressed("ui_right"):		
		velocity += Vector2(100, 0)
		
				

func collide(collision : KinematicCollision2D) -> void:
	var block : Block = collision.collider as Block
	
	if next_block == null: # First block in the level
		next_block = block.next_block
	else:
		if check_block(block):
			print(name, 'Good')
			if block.next_block:
				next_block = block.next_block

		else:
			print(name, 'Bad')

	block.contact()
	bounce_limit = block.bounce_limit

	last_block = block


# Check if a block is touched in correct order.
func check_block(block : Block) -> bool:
	return block == next_block or block == last_block
		

func drop():
	gravity = initial_gravity

func stop():
	$CollisionShape2D.disabled = true
	gravity = Vector2(0, 0)
	velocity = Vector2(0, 0)
	

func _on_Area2D_area_entered(area):
	if area.name == 'End':
		emit_signal("reached_end")
		

func tween_to(new_position : Vector2) -> void:
	$Tween.interpolate_property(self, 'position', position, new_position, 4,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
	$Tween.start()
	$Area2D/CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = true


func _on_Tween_tween_completed(object, key):
	pass#	emit_signal("position_reached")
