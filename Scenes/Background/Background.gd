extends ParallaxBackground

export (PackedScene) var floater


var left = Vector2()

func _process(delta):
	left = ($ParallaxLayer2.position - $ParallaxLayer2.get_global_transform_with_canvas().origin)


func _on_Timer_timeout():
	add_floater()
	

func add_floater():
	var rnd = randi() % 4
	var y = 0
	var x = 0
	var angle = 0
	match rnd:
		0: # Top
			y = 0
			x = rand_range(0, 720)
			angle = rand_range(405, 495)
			
		1: # Bottom
			y = 1280
			x = rand_range(0, 720)
			angle = rand_range(585, 675)
			
		2: # Left
			x = 0
			y = rand_range(0, 1280)
			angle = rand_range(315, 405)
		3: # Right
			x = 720
			y = rand_range(0, 1280)
			angle = rand_range(495, 585)
		
	var vec = Vector2(x, y) + -$ParallaxLayer2.position			
	var f = floater.instance()
	$ParallaxLayer2.add_child(f)
	f.position = vec
	f.rotation_degrees = angle