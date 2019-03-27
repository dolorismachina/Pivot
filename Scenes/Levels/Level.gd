extends Node2D


var previous_position : Vector2 = Vector2()
var distance_moved : Vector2 = Vector2()


func follow_player(player):
	$Pivot.position += (player.position + Vector2(0, -100) - $Pivot.position) * 0.4
	
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
	print(blocks)
	
	for b in blocks:
		var block = (b as Block)
		block.disable()
		
	blocks[0].enable()
	blocks[0].show()
	

func get_start_position() -> Vector2:
	return $Pivot/Content/Start.position
	

func on_player_reached_start() -> void:
	print('kupa')
	

func disable_collision():
	var blocks = $Pivot/Content/Blocks.get_children()
	
	for b in blocks:
		b.disable_collision()