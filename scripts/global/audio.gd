extends Node

enum Sounds {
	LAND,
}
enum Ambient {
	COOKED,
    BURNT,
}
enum Music {
	MENU,
}

const _SFX = {
	Sounds.LAND: preload("res://assets/sound/sfx/land.wav"),
	Sounds.BOUNCE: preload("res://assets/sound/sfx/bounce.wav"),
	Sounds.TICK: preload("res://assets/sound/sfx/tick_tock.wav"),
}
# Functionally a constant, however pre-loading every ambient line seems inefficient
var _AMBIENT = {
	Ambient.WELCOME: load("res://assets/sound/ambient/glorble_welcome.wav"),
}
const _MUSIC = {
	Music.MENU: "",
}

var ambient_player: AudioStreamPlayer
var music_player: AudioStreamPlayer

func _ready():
	# Ambient
	ambient_player = AudioStreamPlayer.new()
	ambient_player.volume_db = 0
	add_child(ambient_player)
	
	# Music
	music_player = AudioStreamPlayer.new()
	music_player.volume_db = -35
	add_child(music_player)
	
	# Play on startup
	#play_music(Music.MENU)

## Instances a new AudioStreamPlayer to play the sound. Player is destroyed when
## the finished signal is emitted.
func play_sfx(value: Sounds):
	if !_SFX.has(value):
		print("No SFX loaded for ", value)
		return 1
	var sound_player = AudioStreamPlayer.new()
	sound_player.volume_db = -10
	add_child(sound_player)
	sound_player.stream = _SFX[value]
	sound_player.finished.connect(sound_player.queue_free)
	sound_player.play()

func play_ambient(value: Ambient):
	if !_AMBIENT.has(value):
		push_warning("No ambient sound loaded for ", value)
		return 1
	ambient_player.stop()
	ambient_player.stream = _AMBIENT[value]
	ambient_player.play()

func play_music(value: Music):
	if !_MUSIC.has(value):
		print("No music loaded for ", value)
		return 1
	music_player.stop()
	music_player.stream = _MUSIC[value]
	music_player.play()
