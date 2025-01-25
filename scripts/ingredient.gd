extends RigidBody2D

class_name Ingredient

const COOK_RATE = 0.2
const BURN_PERCENT = 1.40

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
@onready var animation_player: AnimationPlayer = $AnimationPlayer

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
	time_cooked += temperature * COOK_RATE
	if time_cooked > BURN_PERCENT:
		_set_state(COOK_STATES.BURNT)

func _set_state(new_state = COOK_STATES.RAW):
	state = new_state
	_set_sprite()
	if state == COOK_STATES.BURNT:
		# TODO Play sound of burning
		pass
