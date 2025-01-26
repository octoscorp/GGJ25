extends Label

signal time_completed

var time_remaining = 0

func _ready():
	$Timer.timeout.connect(_decrement_timer)
	
func _decrement_timer():
	time_remaining -= 1
	if time_remaining >= 0:
		text = str(time_remaining) + "seconds"
	else:
		stop()
		time_completed.emit()

func stop():
	$Timer.stop()

func start(time):
	time_remaining = time
	text = str(time_remaining) + "seconds"
	$Timer.start()
