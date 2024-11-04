extends ProgressBar

var seconds = 30.0

func time() -> void:
	seconds = 30.0
	set_process(true)  # Start the _process function to update every frame

func _ready():
	set_process(false)

func cancel() -> void:
	set_process(false)

func _process(delta):
	if seconds > 0:
		seconds -= delta  # Decrease the countdown
		value = seconds  # Update the progress bar value
	else:
		seconds = 0  # Ensure it stops at 0
		set_process(false)  # Stop the process function when countdown reaches 0
		get_node(Paths.problem).multiple_choice_timeout()
