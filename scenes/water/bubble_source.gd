class_name BubbleSource extends WaterSource

var bubble_cooldown = 0.2
var bubbling = false
var bubble_life_span = 1.0

@onready var start_y = position.y

func _on_timer_timeout() -> void:
	if bubbling:
		spawn_water()
	$Timer.wait_time = max(0.001, bubble_cooldown)
	$Timer.start()


func spawn_water():
	super.spawn_water()
	var pair = objects[-1]
	var tween = create_tween()
	tween.tween_method(grow_bubble.bind(pair), 0.0, 1.0, 0.3)
	pair.append(bubble_life_span)

func grow_bubble(size:float, triplet):
	if triplet[2] <= 0: # bubble has already popped
		return
	var body = triplet[0]
	var img = triplet[1]
	var tform := PhysicsServer2D.body_get_state(body, PhysicsServer2D.BODY_STATE_TRANSFORM) as Transform2D
	tform.origin -= global_position
	tform.x = Vector2(size, 0)
	tform.y = Vector2(0, size)
	RenderingServer.canvas_item_set_transform(img, tform.scaled_local(Vector2.ONE * size))

func _physics_process(delta: float) -> void:
	# Here's hoping there's exactly one flame in the scene :)))
	var flame = get_tree().get_nodes_in_group("Flame")[0] as Node2D
	global_position.x = flame.global_position.x
	var dist = global_position.distance_to(flame.global_position)
	position.y = start_y
	
	bubble_cooldown = max(0, remap(dist, 32, 72, 0, 0.2))
	bubbling = dist < 72
	bubble_life_span = randf_range(0.1, remap(dist, 32, 72, 0.5, 0.1))
	
	super._physics_process(delta)
	var i = 0
	for triplet in objects:
		triplet[2] -= delta
		if triplet[2] <= 0:
			delete_water(triplet)
