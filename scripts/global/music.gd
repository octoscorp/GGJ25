extends AudioStreamPlayer

const BE_HAPPY = preload("res://media/music/Be_Happy.mp3")
const DONT_WORRY = preload("res://media/music/Dont_Worry.mp3")
const FRANTIS_SHRIMP = preload("res://media/music/Frantis_Shrimp.mp3")

func _ready() -> void:
	volume_db = linear_to_db(0.1)

func play_song(song: AudioStream):
	stream = song
	play()
