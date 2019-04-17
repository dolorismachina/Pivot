extends Node2D
class_name Level


signal rotated(direction, angle) # -1 for left, +1 for right


var previous_position : Vector2 = Vector2()
var distance_moved : Vector2 = Vector2()


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
	reset_collectables()
	$LevelController.disable()


func reset_collectables():
	var items = $Pivot/Content/Collectables.get_children()
	for item in items:
		item.reset()
			

func reset_blocks():
	# Reset blocks to default state
	var blocks = $Pivot/Content/Blocks.get_children()
	for block in blocks:
		if not block is Block:
			return
			
		block = (block as Block)
		block.reset()
		block.deactivate()
		
		
func start():
	$LevelController.enable()
	
	for block in $Pivot/Content/Blocks.get_children():
		if not block is Block:
			return
			
		(block as Block).activate()
	
	
func get_start_position() -> Vector2:
	return $Pivot/Content/Start.position
	

func on_player_reached_start() -> void:
	print('kupa')
	

func disable_collision():
	var blocks = $Pivot/Content/Blocks.get_children()
	
	for b in blocks:
		b.disable_collision()
		