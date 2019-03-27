extends Node2D

export (NodePath) var blocks_path
export (int) var move_distance = 50

func _input(event):
	if event.is_action_pressed('ui_left'):
		move(1)
	if event.is_action_pressed('ui_right'):
		move(-1)
		
func move(direction : float):
	var blocks = get_node(blocks_path)
	$Tween.interpolate_property(blocks, 'position',
	blocks.position, blocks.position + Vector2(move_distance, 0) * direction,
	0.25, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	
	$Tween.start()