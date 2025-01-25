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

func _ready() -> void:
	next_event()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_event"):
		next_event()

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

func animate_text(label : Label, text : String):
	label.text = ""
	for char in text:
		label.text += char
		await get_tree().create_timer(0.02).timeout

func delay(seconds):
	await get_tree().create_timer(seconds).timeout
