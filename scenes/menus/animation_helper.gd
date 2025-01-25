extends CanvasItem

signal text_finished()

@export var target_label : Label
@export var start_hidden = false


func _ready() -> void:
	if start_hidden:
		hide()

func appear():
	var tween = create_tween()
	show()
	tween.tween_property(self, "rotation", 0, 0.5).from(0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(self, "scale", Vector2.ONE, 0.2).from(Vector2.ONE*0.9).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
