extends KinematicBody2D
class_name Player


signal reached_end
signal position_reached
signal obstacle_touched
signal collectable_collected(value)


export (int) var bounce_limit = 500
export (float) var horizontal_damping = 0.985

var velocity = Vector2(0, 0)
var initial_gravity = Vector2(0, 1050)
var gravity = Vector2(0, 0)
var next_block : Block
var last_block : Block


func _physics_process(delta):
	rotation = velocity.angle()
	var collision : KinematicCollision2D = move(delta)
	
	if collision:
		collide(collision)
			
		$Audio.play()
		#$AnimationPlayer.play("bounce")
		bounce(collision.normal)
		
		
func move(delta) -> KinematicCollision2D:
	velocity += gravity * delta
	velocity.y = clamp(velocity.y, -bounce_limit, bounce_limit)
	velocity.x *= horizontal_damping
	
	return move_and_collide(velocity * delta)
	
	
func collide(collision : KinematicCollision2D) -> void:
	var block : Block = collision.collider as Block
	
	if next_block == null: # First block in the level
		next_block = block.next_block
	else:
		if check_block(block):
			if block.next_block:
				next_block = block.next_block

	block.contact()
	bounce_limit = block.bounce_limit

	last_block = block


func bounce(normal):
	if normal.y == 1 or normal.y == -1:
		velocity = bounce_perpendicular(normal)
	else:
		velocity = bounce_proper(normal)

	velocity = bounce_perpendicular(normal)
		

# Return vector perpendicular to collision normal.	
func bounce_perpendicular(normal : Vector2) -> Vector2:
	return normal * bounce_limit


# Return vector bounced off the collision normal.
func bounce_proper(normal : Vector2) -> Vector2:
	var velocity_bounced = velocity.normalized().bounce(normal)
	var mid = velocity_bounced.linear_interpolate(normal, 0.5)
	
	return mid * bounce_limit
	
	
func adjust_velocity():
	var factor = velocity.y / bounce_limit
	
	if  velocity.y < 0:
		velocity.y = -velocity.y / factor
	else:
		velocity.y = velocity.y / factor	
		
		
# Check if a block is touched in correct order.
func check_block(block : Block) -> bool:
	return block == next_block or block == last_block
		

func drop():
	gravity = initial_gravity
	enable()


func stop():
	$CollisionShape2D.call_deferred("set_disabled", true)
	gravity = Vector2(0, 0)
	velocity = Vector2(0, 0)
	
	
func enable():
	$CollisionShape2D.disabled = false
	


func _on_Area2D_area_entered(area):
	if area.is_in_group('collectables'):
		print('Got a collectable!')
		area.collect()
		emit_signal("collectable_collected", area.value)
		
		return 
		
	if area.is_in_group('enemies'):
		emit_signal("obstacle_touched")
		return
		
	if area.is_in_group('obstacles'):
		print('Hit obstacle')
		emit_signal("obstacle_touched")
		return
		
	if area.name == 'End':
		emit_signal("reached_end")
		return
		

func tween_to(new_position : Vector2) -> void:
	$Tween.interpolate_property(self, 'position', position, new_position, 4,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
	$Tween.start()
	$CollisionShape2D.disabled = true


func _on_Tween_tween_completed(object, key):
	pass#	emit_signal("position_reached")


func on_level_rotated(direction, angle):
	velocity = velocity.rotated(deg2rad((angle / 1.5) * direction))
