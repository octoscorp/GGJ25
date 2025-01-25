extends Node2D


@onready var events = [
	auto_next_event.bind(
		play_anim.bind("intro")),
	animate_text.bind(%SpeechLabel, "What's up home slice?"),
	animate_text.bind(%SpeechLabel, "Give me a very Shrimpy meal :)"),
	animate_text.bind(%SpeechLabel, "yeah let's fuckin GOOOOOOOOOOOO"),
	get_tree().change_scene_to_file.bind("res://scenes/Kitchen.tscn"),
	]


var event_index = 0
var cut_off = false
var text_to_print = ""
var text_index = 0
var text_label : Label

func _ready() -> void:
	next_event()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_event"):
		next_event()
		cut_off = true

func next_event():
	if event_index < events.size():
		events[event_index].call()
	event_index += 1

func auto_next_event(event : Callable):
	await event.call()
	next_event()

func play_anim(animation : String):
	$AnimationPlayer.play(animation)
	await $AnimationPlayer.animation_finished

func _process(delta: float) -> void:
	if text_label != null:
		text_index += delta*50
		text_label.text = text_to_print.substr(0, int(text_index))

func animate_text(label : Label, text : String):
	# finish off old text if it's on a different label first
	if text_label!=null:
		text_label.text = text_to_print
	
	text_to_print = text
	text_index = 0
	text_label = label
	text_label.text = ""

func delay(seconds):
	await get_tree().create_timer(seconds).timeout
