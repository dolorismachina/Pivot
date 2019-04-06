extends Node2D
class_name Level


signal rotated(direction, angle) # -1 for left, +1 for right


var previous_position : Vector2 = Vector2()
var distance_moved : Vector2 = Vector2()


func _process(delta):
	$MouseController.update_position($Pivot.get_global_transform_with_canvas().origin)


func follow_player(player):
	$Pivot.position = player.position - position + Vector2(0, -100)
	
	distance_moved = $Pivot.position - previous_position
	previous_position = $Pivot.position
	$Pivot/Content.global_translate(distance_moved * -1)
	
	
func reset():
	$Pivot.position = Vector2(0, 0)
	$Pivot/Content.position = Vector2(0, 0)
	distance_moved = Vector2(0, 0)
	previous_position = $Pivot.position
	$Pivot.rotation = 0
	$Pivot.rotation_degrees = 0
	
	reset_blocks()
	

func reset_blocks():
	var blocks = $Pivot/Content/Blocks.get_children()
	
	for b in blocks:
		if not b is Block:
			return
			
		var block = (b as Block)
		
		
func start():
	#reset_blocks()
	pass
	
	
func get_start_position() -> Vector2:
	return $Pivot/Content/Start.position
	

func on_player_reached_start() -> void:
	print('kupa')
	

func disable_collision():
	var blocks = $Pivot/Content/Blocks.get_children()
	
	for b in blocks:
		b.disable_collision()