extends RigidBody2D

class_name Ingredient

const COOK_RATE = 0.00005
const BURN_PERCENT = 1.60
const MAXIMUM_COOK_DISTANCE = 300
const MAX_TEMP = 140

const COOK_TIMES = {
	INGREDIENTS.SHRIMP: 10.0,
}

enum COOK_STATES {
	RAW,
	MEDIUM,
	COOKED,
	BURNT,
}

const food_filename = {
	INGREDIENTS.SHRIMP: "shrimp",
}

const cooked_prefix = {
	COOK_STATES.RAW: "raw",
	COOK_STATES.MEDIUM: "medium",
	COOK_STATES.COOKED: "cooked",
	COOK_STATES.BURNT: "burnt",
}

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

var ingr_type
var cook_time: float
var shape: PackedVector2Array
var time_cooked = 0
var state = COOK_STATES.RAW

var temperature = 0;

# Called when the Ingredient is created (Ingredient.new(args)
func _init(type = INGREDIENTS.SHRIMP) -> void:
	ingr_type = type
	cook_time = COOK_TIMES[type]
	shape = INGREDIENTS.SHAPES[type]
	for i in shape.size():
		shape[i] = Vector2(shape[i])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set collision shape and sprite
	collision_polygon_2d.polygon = shape
	_set_sprite()

func _set_sprite():
	#var file = load("res://media/" + cooked_prefix[state] + "_" + food_filename[ingr_type] + ".png")
	#sprite_2d.texture = file
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Movement (if necessary)

	# Cook the ingredient
	if state == COOK_STATES.BURNT:
		return
	_calculate_temperature()
	time_cooked += temperature * COOK_RATE
	if time_cooked > BURN_PERCENT * cook_time:
		_set_state(COOK_STATES.BURNT)
	elif time_cooked >= cook_time and state <= COOK_STATES.MEDIUM:
		_set_state(COOK_STATES.COOKED)
	elif time_cooked >= cook_time / 2  and state == COOK_STATES.RAW:
		_set_state(COOK_STATES.MEDIUM)

func _calculate_temperature():
	var flame = get_tree().get_nodes_in_group("Flame")[0] as Node2D
	var distance_to_flame = (flame.position - position).length()
	
	temperature = clampf(MAXIMUM_COOK_DISTANCE - distance_to_flame, 0, MAX_TEMP)

func _set_state(new_state = COOK_STATES.RAW):
	state = new_state
	_set_sprite()
	print("State set to " + cooked_prefix[state])
	if state == COOK_STATES.BURNT:
		# TODO Play sound of burning
		pass
