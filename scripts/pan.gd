extends Node2D

# Spring strength
const STIFFNESS = 0.27
# How much to rotate body for vertical movement
const ROTATION_STRENGTH = 0.21
const ROTATION_LIMIT = 30

# The handle is referred to often enough to warrant defining it as a var
@onready var handle: StaticBody2D = $Handle
@onready var body: StaticBody2D = $Body

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
	# Work out handle movement relative to body
	var target = handle.position - body_handle_offset
	
	# Move body to match handle movement
	spr_x_change = lerpf(spr_x_change, (target.x - body.position.x) * 0.5, STIFFNESS)
	body.position.x += spr_x_change
	
	spr_y_change = lerpf(spr_y_change, (target.y - body.position.y) * 0.5, STIFFNESS)
	body.position.y += spr_y_change
	
	# Rotate body based on vertical movement
	body.rotation_degrees = clampf(spr_y_change * ROTATION_STRENGTH, -ROTATION_LIMIT, ROTATION_LIMIT)
	
	# Move handle to mouse location
	# This is done last to make the body "lag" a tick behind the handle
	if selected:
		handle.position = get_viewport().get_mouse_position() + mouse_offset

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

# Handle emits a signal when mouse enters - catch and handle it
func _on_handle_mouse_entered() -> void:
	hovered = true

# Handle emits a signal when mouse exits - catch and handle it
func _on_handle_mouse_exited() -> void:
	hovered = false
