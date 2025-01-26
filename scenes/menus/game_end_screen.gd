class_name GameEndScreen extends Control

const END_SCREEN_PATH = "res://scenes/menus/game_end_screen.tscn"

class GameInfo:
	var next_scene : String
	var score: int
	var min_score: int
	var max_score: int

static var game_info: GameInfo

@onready var next_button: TextureButton = $NextButton
@onready var sting_sfx: AudioStreamPlayer = $StingSFX

static func _static_init() -> void:
	game_info = GameInfo.new()

static func summon(score, max_score, min_score, next_scene = "res://scenes/Kitchen.tscn"):
	var tree = (Engine.get_main_loop() as SceneTree)
	if score < min_score:
		next_scene = tree.current_scene.scene_file_path
		
	game_info.next_scene = next_scene
	game_info.score = score
	game_info.min_score = min_score
	game_info.max_score = max_score
	
	tree.change_scene_to_file.call_deferred(END_SCREEN_PATH)

func _ready() -> void:
	var won = game_info.score > game_info.min_score
	if won:
		#next_button.self_modulate = Color.GREEN
		$BackgroundBad.hide()
		sting_sfx.stream = preload("res://media/sfx/sting_success.mp3")
		sting_sfx.play()
		$FinalScore.text = "%dpts" % game_info.score
	else:
		#next_button.self_modulate = Color.RED
		$BackgroundGood.hide()
		sting_sfx.stream = preload("res://media/sfx/sting_fail.mp3")
		sting_sfx.play()
		$FinalScore.text = "%d/%dpts" % [game_info.score, game_info.max_score]


func _on_next_level_pressed() -> void:
	get_tree().change_scene_to_file(game_info.next_scene)
