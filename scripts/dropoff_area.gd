extends Area2D

signal no_ingredients_left

var total_ingredients = 0
var score = 0
var completed = 0

const DROPOFF_AREA = preload("res://scenes/PointsScoredLabel.tscn")

func _ready() -> void:
	(func():total_ingredients = get_tree().get_nodes_in_group("Ingredients").size()).call_deferred()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("get_score_value"):
		score += body.get_score_value()
		var pos = body.global_position
		var amt = body.get_score_value()
		show_score_num.call_deferred(amt, pos)
		_delete_from_world.call_deferred(body)

func show_score_num(score_amount, pos):
	var display = DROPOFF_AREA.instantiate()
	display.set_score(score_amount)
	add_child(display)
	display.global_position = pos + Vector2(randi_range(-100, 100), -20)

func _delete_from_world(body):
	body.freeze = true
	body.gravity_scale = 0
	body.set_collision_layer_value(2, false)
	for i in range(1,5):
		body.set_collision_mask_value(i, false)
	completed += 1
	if completed >= total_ingredients:
		no_ingredients_left.emit()

func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.has_method("get_score_value"):
		_delete_from_world.call_deferred(body)
