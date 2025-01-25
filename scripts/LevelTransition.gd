extends Button

#get_parent().get_node("Node_Name").Variable_Name
@export_file("*.tscn") var scene


func _on_button_down() -> void:
	get_tree().change_scene_to_file(scene)
