
extends Node2D

func _ready():
  for i in get_children():
    print(i.position)

  

func _on_Blocks_draw():
  update()


func _on_Blocks_visibility_changed():
  for i in get_children():
    pass