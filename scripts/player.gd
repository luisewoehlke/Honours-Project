extends CharacterBody2D

var speed: int = 100

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta):
	player_movement(delta)

# Handle player input
func player_movement(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	move_and_slide()
