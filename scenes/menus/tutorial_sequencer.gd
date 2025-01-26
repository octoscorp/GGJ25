extends Node2D

@onready var chatter_sfx: AudioStreamPlayer = $ChatterSFX

@onready var events = [
	auto_next_event.bind($TextBox.appear),
	animate_text.bind(%SpeechLabel, "Cookin shrimp? That's my fav! The pot needs to boil. Click and drag the handle to move the pot."),
	animate_text.bind(%SpeechLabel, "The shrimp is not quite done yet, its gota be juuust right. ^u^"),
	animate_text.bind(%SpeechLabel, "It's done now, scoop out onto a plate. *u*"),
	auto_next_event.bind(animate_text.bind(%SpeechLabel, "Good shrimp :)")),
	finish
	]

var finished = false

var event_index = 0
var cut_off = false
var text_to_print = ""
var text_index = 0
var text_label : Label

func _ready() -> void:
	next_event()

func finish():
	finished = true
	$TextureButton/RestartButton.text = "Menu"
	$TextureButton.self_modulate = Color.GREEN

#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("next_event"):
#		next_event()
#		cut_off = true

func next_event():
	print("LET'S GO") 
	if event_index < events.size():
		event_index += 1
		events[event_index-1].call()
	

func auto_next_event(event : Callable):
	await event.call()
	next_event()

func play_anim(animation : String):
	$AnimationPlayer.play(animation)
	await $AnimationPlayer.animation_finished

func _process(delta: float) -> void:
	if text_label != null:
		text_index += delta*30
		text_label.text = text_to_print.substr(0, int(text_index))
		chatter_sfx.stream_paused = int(text_index) > text_to_print.length()

func animate_text(label : Label, text : String):
	# finish off old text if it's on a different label first
	if text_label!=null:
		text_label.text = text_to_print
	
	chatter_sfx.play(chatter_sfx.stream.get_length() * randf())
	text_to_print = text
	text_index = 0
	text_label = label
	text_label.text = ""

func delay(seconds):
	await get_tree().create_timer(seconds).timeout


func _on_shrimp_cook_progress() -> void:
	next_event()


func _on_dropoff_area_no_ingredients_left() -> void:
	next_event()

func _on_restart_button_pressed() -> void:
	if finished:
		get_tree().change_scene_to_file("res://scenes/menus/StartMenu.tscn")
	else:
		get_tree().reload_current_scene()
