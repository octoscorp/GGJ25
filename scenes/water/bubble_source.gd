class_name BubbleSource extends WaterSource

var bubble_cooldown = 0.2
var bubbling = false
var bubble_life_span = 1.0

@onready var start_y = position.y
@export var left_limit: Node2D
@export var right_limit: Node2D

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
	pair.append(0.0) # size

func delete_water(obj_data):
	var pos = (PhysicsServer2D.body_get_state(obj_data[0], PhysicsServer2D.BODY_STATE_TRANSFORM) as Transform2D).origin
	var pop_fx = preload("res://scenes/water/pop_fx.tscn").instantiate()
	add_child(pop_fx)
	pop_fx.global_position = pos
	pop_fx.scale = Vector2.ONE * obj_data[3]
	super.delete_water(obj_data)
	

func grow_bubble(size:float, data):
	if data[2] <= 0: # bubble has already popped
		return
	var body = data[0]
	var img = data[1]
	var tform := PhysicsServer2D.body_get_state(body, PhysicsServer2D.BODY_STATE_TRANSFORM) as Transform2D
	tform.origin -= global_position
	tform.x = Vector2(size, 0)
	tform.y = Vector2(0, size)
	RenderingServer.canvas_item_set_transform(img, tform.scaled_local(Vector2.ONE * size))

func _physics_process(delta: float) -> void:
	# Here's hoping there's exactly one flame in the scene :)))
	var flame = get_tree().get_nodes_in_group("Flame")[0] as Node2D
	global_position.x = clampf(flame.global_position.x, left_limit.global_position.x, right_limit.global_position.x)
	var dist = global_position.distance_to(flame.global_position)
	position.y = start_y
	
	bubble_cooldown = max(0, remap(dist, 32, 72, 0, 0.2))
	bubbling = dist < 72
	bubble_life_span = randf_range(0.1, remap(dist, 32, 72, 0.5, 0.1))
	
	super._physics_process(delta)
	var i = 0
	for data in objects:
		data[2] -= delta
		if data[2] <= 0:
			delete_water(data)
		data[3] += delta*3
		data[3] = clampf(data[3], 0.0, 1.0)
