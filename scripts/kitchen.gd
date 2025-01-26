extends Node2D
# Manages level aspects etc
@onready var ingr_spawn: Node2D = $IngredientSpawnLocation

@export var level_duration_seconds: int = 30
@export var recipe_ingredients: Array[INGREDIENTS.TYPE] = [
	INGREDIENTS.TYPE.SHRIMP,
	INGREDIENTS.TYPE.SHRIMP,
	INGREDIENTS.TYPE.SHRIMP,
	INGREDIENTS.TYPE.SHRIMP,
	INGREDIENTS.TYPE.SHRIMP,
	INGREDIENTS.TYPE.SHRIMP,
	INGREDIENTS.TYPE.SHRIMP,
	INGREDIENTS.TYPE.SHRIMP,
	INGREDIENTS.TYPE.SHRIMP,
	INGREDIENTS.TYPE.SHRIMP,
	INGREDIENTS.TYPE.SHRIMP,
	INGREDIENTS.TYPE.SHRIMP,
]

var scene = {
	INGREDIENTS.TYPE.SHRIMP: preload("res://scenes/ingredients/shrimp.tscn"),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var offset = Vector2(0,0)
	for ingr in recipe_ingredients:
		var ingr_node = scene[ingr].instantiate()
		ingr_node.position = ingr_spawn.position + offset
		add_child(ingr_node)
		
		offset.x += 60
		if offset.x > 300:
			offset.x = 0
			offset.y += 60
	# Start timer
	$TimerDisplay.start(level_duration_seconds)

func level_end():
	var score = $DropoffArea.score
	# TODO: connect to win/loss screens

func _on_dropoff_area_no_ingredients_left() -> void:
	# This tells us when all ingredients are gone (including by killzone)
	$TimerDisplay.stop()
	level_end()


func _on_timer_display_time_completed() -> void:
	level_end()
