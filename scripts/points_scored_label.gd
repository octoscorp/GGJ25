extends Label

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.animation_finished.connect(_remove)
	animation_player.play("float")
	print("Added to scene_tree")

func set_score(score):
	var contents = ""
	if score > 0:
		contents += "+"
	contents += str(score)
	
	text = contents

func _remove(_something):
	queue_free()
