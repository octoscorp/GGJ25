extends Area2D

var score = 0

func _on_body_entered(body: Node2D) -> void:
	print(body)
	if body.has_method("get_score_value"):
		score += body.get_score_value()
		body.queue_free()
