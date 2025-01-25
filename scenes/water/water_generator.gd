class_name WaterSource extends Node2D
var objects: Array[Array] = []

@export var starting_water : int = 0

@export var water_texture: Texture2D
@export var spawnRad: float
@export var debug_spawn_action : String
@export var particle_size := 4.0
@export var texture_size := 32.0
@export var gravity_scale := 1.0
@export var damping := 0
@export var mass := 0.1
@export_flags_2d_physics var water_layer = 1
@export_flags_2d_physics var water_mask = 1

@onready var cir_shape := CircleShape2D.new()

func _ready() -> void:
	cir_shape.radius = particle_size/2
	cir_shape.custom_solver_bias = 0.1
	for i in starting_water:
		spawn_water()


func create_object(pos: Vector2):
	var ps := PhysicsServer2D
	var object = ps.body_create()
	ps.body_set_space(object, get_world_2d().space)
	ps.body_add_shape(object, cir_shape)
	ps.body_set_param(object, ps.BODY_PARAM_FRICTION, 0.0)
	ps.body_set_param(object, ps.BODY_PARAM_MASS, mass)
	ps.body_set_param(object, ps.BODY_PARAM_GRAVITY_SCALE, gravity_scale)
	ps.body_set_param(object, ps.BODY_PARAM_LINEAR_DAMP, damping)
	ps.body_set_collision_layer(object, water_layer)
	ps.body_set_collision_mask(object, water_mask)
	var trans := Transform2D(0, pos)
	ps.body_set_state(object, ps.BODY_STATE_TRANSFORM, trans)
	
	#await get_tree().create_timer(0.5).timeout
	#DumpEverything.dump_body(object)
	#print("---")
	#DumpEverything.dump_body($"../../RigidBody2D")
	#breakpoint
	

	var rs := RenderingServer
	var img := rs.canvas_item_create()
	rs.canvas_item_set_parent(img, get_canvas_item())
	rs.canvas_item_add_texture_rect(img, Rect2(texture_size/-2, texture_size/-2, texture_size, texture_size), water_texture)

	objects.append([object, img])

func _physics_process(delta):
	var index: int = 0
	for pair in objects:
		var object: RID = pair[0]
		var img: RID = pair[1]
		var trans: Transform2D = PhysicsServer2D.body_get_state(object, PhysicsServer2D.BODY_STATE_TRANSFORM)
		trans.origin -= global_position
		if trans.origin.y > 648*2 - global_position.y:
			delete_water(pair)
		else:
			RenderingServer.canvas_item_set_transform(img, trans)
			PhysicsServer2D.body_apply_central_impulse(object, Vector2.RIGHT.rotated(randf()*TAU)*2)
		index += 1



func _exit_tree():
	for pair in objects:
		var object: RID = pair[0]
		var img: RID = pair[1]
		PhysicsServer2D.free_rid(object)
		RenderingServer.free_rid(img)

func spawn_water():
	create_object(global_position + Vector2(randf()-0.5, randf()-0.5).normalized()*spawnRad*randf())

func delete_water(obj):
	objects.erase(obj)
	PhysicsServer2D.free_rid(obj[0])
	RenderingServer.free_rid(obj[1])
	

func _process(delta: float) -> void:
	if OS.is_debug_build() and\
	debug_spawn_action in InputMap.get_actions() and\
	Input.is_action_pressed(debug_spawn_action):
		spawn_water()
