extends Node2D

# Spring strength
const STIFFNESS = 0.27
# How much to rotate body for vertical movement
const ROTATION_STRENGTH = 0.21
const ROTATION_LIMIT = 30

# The handle is referred to often enough to warrant defining it as a var
@onready var handle: StaticBody2D = $Handle
@onready var body: StaticBody2D = $Body
@onready var stove_cast: RayCast2D = $Handle/StoveCast

# Bool representing when the mouse is over the handle
var hovered = false
# Bool representing when the handle is selected
var selected = false
# Mouse offset from centre of handle (so it doesn't just grab centre by the centre)
var mouse_offset = Vector2(0,0)

# Offset of handle from body - variable so we can tweak easily
var body_handle_offset: Vector2
var spr_x_change = 0
var spr_y_change = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_handle_offset = handle.position - body.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Called every physics frame (close to constant time). 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	
	# Animated bodies only like one tform update per phys step so we'll defer
	# the update to the end of the step
	var b_pos = body.position

	
	# Work out handle movement relative to body
	var target = handle.position - body_handle_offset
	
	# Move body to match handle movement
	spr_x_change = lerpf(spr_x_change, (target.x - b_pos.x) * 0.5, STIFFNESS)
	b_pos.x += spr_x_change
	
	spr_y_change = lerpf(spr_y_change, (target.y - b_pos.y) * 0.5, STIFFNESS)
	b_pos.y += spr_y_change
		
	# Rotate body based on vertical movement
	var rot_deg = clampf(spr_y_change * ROTATION_STRENGTH, -ROTATION_LIMIT, ROTATION_LIMIT)
	
	# Perform transform update
	var rot_rad = deg_to_rad(rot_deg)
	var b_tform = Transform2D.IDENTITY.rotated(rot_rad)
	b_tform.origin = b_pos
	body.transform = b_tform
	if Input.is_action_pressed("ui_accept"):
		b_tform.origin.y += 100
		body.transform = b_tform
	
	# Move handle to mouse location
	# This is done last to make the body "lag" a tick behind the handle
	if selected:
		handle.position = get_viewport().get_mouse_position() + mouse_offset
	# Prevent pan from going through the stove
		stove_cast.force_raycast_update()
		if stove_cast.is_colliding():
			handle.position += stove_cast.get_collision_point() - stove_cast.to_global(stove_cast.target_position)

# Called every time the game receives input
func _input(event: InputEvent) -> void:
	# Look at Project -> Project Settings -> Input Map
	# Become selected when clicked on
	if event.is_action_pressed('select') and hovered == true:
		selected = true
		mouse_offset = handle.position - get_viewport().get_mouse_position()
	# Become unselected on mouse up
	if event.is_action_released('select'):
		selected = false

# Return true if point is inside the pan
func is_in_pan(point: Vector2):
	if point.x > $Body/TopRightLimit.position.x or point.x < $Body/BotLeftLimit.position.x:
		return false
	if point.y > $Body/TopRightLimit.position.y or point.y < $Body/BotLeftLimit.position.y:
		return false
	return true

# Handle emits a signal when mouse enters - catch and handle it
func _on_handle_mouse_entered() -> void:
	hovered = true

# Handle emits a signal when mouse exits - catch and handle it
func _on_handle_mouse_exited() -> void:
	hovered = false
