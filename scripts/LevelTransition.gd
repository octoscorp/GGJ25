extends Button

#get_parent().get_node("Node_Name").Variable_Name
@export var scene = preload("res://scenes/Kitchen.tscn").instantiate()


func _on_button_down() -> void:
	#get_node("/root/Main").free()
	get_tree().root.add_child(scene)
	#get_node("/root/Main").free()
	#get_tree().current_scene = scene
