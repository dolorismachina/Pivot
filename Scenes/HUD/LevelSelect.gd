extends Control

signal level_selected(id)


func _ready():
	for i in $GridContainer.get_children():
		if i.is_in_group("level_select_button"):
			i.connect("level_selected", self, "on_level_selected")
			
			
func on_level_selected(id):
	visible = false
	print("SSS")
	emit_signal("level_selected", id)
