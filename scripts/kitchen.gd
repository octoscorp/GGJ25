extends Node2D

@onready var ingr_spawn: Node2D = $IngredientSpawnLocation

# Manages level aspects etc
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

func level_end():
	var score = $DropoffArea.score
	# TODO: connect to win/loss screens

func _on_dropoff_area_no_ingredients_left() -> void:
	# This tells us when all ingredients are gone (including by killzone)
	level_end()
