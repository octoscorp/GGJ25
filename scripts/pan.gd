extends Node2D

# The handle is referred to often enough to warrant defining it as a var
@onready var handle: StaticBody2D = $Handle

# Bool representing when the mouse is over the handle
var hovered = false
# Bool representing when the handle is selected
var selected = false
# Mouse offset from centre of handle (so it doesn't just grab centre by the centre)
var mouse_offset = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Variables would be initialised here if they weren't all initialised already
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Called every physics frame (close to constant time). 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	# Move to mouse location
	if selected:
		handle.position = get_viewport().get_mouse_position() + mouse_offset

# Called every time the game receives input
func _input(event: InputEvent) -> void:
	# Look at Project -> Project Settings -> Input Map
	# Become selected when clicked on
	if event.is_action_pressed('select') and hovered == true:
		selected = true
		print("Selected")
		mouse_offset = handle.position - get_viewport().get_mouse_position()
	# Become unselected on mouse up
	if event.is_action_released('select'):
		print("Deselected")
		selected = false

# Handle emits a signal when mouse enters - catch and handle it
func _on_handle_mouse_entered() -> void:
	hovered = true

# Handle emits a signal when mouse exits - catch and handle it
func _on_handle_mouse_exited() -> void:
	hovered = false
