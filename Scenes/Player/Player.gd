extends KinematicBody2D
class_name Player


signal reached_end
signal position_reached
signal obstacle_touched
signal collectable_collected(value)
signal fell_off
signal is_waiting


enum State {ACTIVE, WAITING, SLOWING_DOWN, FLYING_AWAY, FLYING_TO_START}
var current_state = State.WAITING

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
	$RespawnTimer.start(0)	
	$CollisionTimer.start(0)
	set_collision_mask_bit(1, false)
	
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
	if current_state == State.WAITING:
		gravity = initial_gravity
		enable()


func stop():
	set_collision_mask_bit(1, false)
	$Area2D.set_collision_mask_bit(1, false)
	
	set_collision_mask_bit(2, false)
	$Area2D.set_collision_mask_bit(2, false)
	
	gravity = Vector2(0, 0)
	velocity = Vector2(0, 0)
	

func reset():
	change_state(State.WAITING)
	
	
func enable():
	set_collision_mask_bit(1, true)
	$Area2D.set_collision_mask_bit(1, true)
	
	set_collision_mask_bit(2, true)
	
	$Area2D.set_collision_mask_bit(2, true)
	
	change_state(State.ACTIVE)
	
	
func focus_camera(focus):
	$Camera2D.current = focus
	

func _on_Area2D_area_entered(area):
	if area.is_in_group('collectables'):
		pick_collectable(area)
		return 
		
	if area.is_in_group('enemies'):
		emit_signal("obstacle_touched")
		return
		
	if area.is_in_group('obstacles'):
		print('Hit obstacle')
		emit_signal("obstacle_touched")
		return
		
	if area.name == 'End':
		change_state(State.SLOWING_DOWN)
		$RespawnTimer.stop()
		slow_down()
		emit_signal("reached_end")
		return
		

func pick_collectable(area):
	print('Got a collectable!')
	area.collect()
	emit_signal("collectable_collected", area.value)
	

# Gradually lowers player's speed to zero
func slow_down():
	change_state(State.SLOWING_DOWN)
	
	$Tween.interpolate_property(self, 'velocity', velocity, Vector2(), 0.5, 
		Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
		
	
func tween_to(new_position : Vector2) -> void:
	change_state(State.FLYING_TO_START)
	
	$Tween.interpolate_property(self, 'position', position, new_position, 4,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
	$Tween.start()
	set_collision_mask_bit(1, false)
	set_collision_mask_bit(2, false)


func fly_away():
	$Tween.interpolate_property(self, 'velocity', Vector2(0, 0), 
		Vector2(0, -1500), 1, Tween.TRANS_CUBIC, Tween.EASE_IN, 0.5)
	$Tween.start()
	
	change_state(State.FLYING_AWAY)


func change_state(new_state):
	match new_state:
		State.WAITING:
			focus_camera(true)
			current_state = State.WAITING
			emit_signal("is_waiting")
		
		State.ACTIVE:
			current_state = State.ACTIVE
			
		State.SLOWING_DOWN:
			current_state = State.SLOWING_DOWN
		
		State.FLYING_AWAY:
			current_state = State.FLYING_AWAY
			focus_camera(false)
		
		State.FLYING_TO_START:
			$Camera2D.current = true
			$Camera2D.smoothing_speed = 0
			$Tween.interpolate_property($Camera2D, 'smoothing_speed', 0, 10, 10,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			current_state = State.FLYING_TO_START		
			
			
func _on_Tween_tween_completed(object, key):
	if current_state == State.FLYING_TO_START:
		change_state(State.WAITING)
		
	if current_state == State.SLOWING_DOWN:
		fly_away()
			

func on_level_rotated(direction, angle):
	velocity = velocity.rotated(deg2rad((angle / 1.5) * direction))


func _on_RespawnTimer_timeout():
	emit_signal("fell_off")


func _on_CollisionTimer_timeout():
	set_collision_mask_bit(1, true)
