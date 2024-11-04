extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_doors_body_entered(body: Node2D) -> void:
	get_node(Paths.level_street).queue_free()
	var level0 = load("res://scenes/levels/level0.tscn").instantiate()
	get_node("/root/Game").add_child(level0)
	get_node(Paths.player).position = Vector2(56,168)
