extends Area2D

signal no_ingredients_left

var total_ingredients = 0
var score = 0
var completed = 0

func _ready() -> void:
	(func():total_ingredients = get_tree().get_nodes_in_group("Ingredients").size()).call_deferred()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("get_score_value"):
		score += body.get_score_value()
		_delete_from_world(body)

func _delete_from_world(body):
	body.queue_free()
	completed += 1
	if completed >= total_ingredients:
		no_ingredients_left.emit()

func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.has_method("get_score_value"):
		_delete_from_world(body)
