extends Node2D

var stonks
var noInteractor: Node2D = Node2D.new()
var interactor: Node2D = noInteractor
enum states {EXPOSITION, GAME}
var state: states = states.EXPOSITION
var exposition: Array[String]
var exposition_i: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stonks = 0
	print("stonks: ", stonks)
	set_up_exposition()

func setup_interactable_signal(npc: StaticBody2D) -> void:
	npc.connect("interactable", _on_npc_interactable)
	npc.connect("not_interactable", _on_npc_not_interactable)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("j"):
		if state == states.EXPOSITION:
			progress_exposition()
		elif state == states.GAME:
			interaction()

func progress_exposition() -> void:
	exposition_i += 1
	if exposition_i == exposition.size():
		state = states.GAME
		get_node(Paths.dialogue_box).visible = false
		get_node(Paths.player).set_physics_process(true)
	else:
		var label = get_node(Paths.dialogue_label)
		label.text = exposition[exposition_i]

func set_up_exposition() -> void:
	exposition = [
		"You wake up on an empty street. Your head hurts. You remember NOTHING.\t\t %c%iPress Ji%c%",
		"Where are you? Why are you a knight?? Your name???\t\t %c%iPress Ji%c%",
		"You decide to call yourself %cLORD RUDOLPHUS IIc% from now on.\t\t %c%iPress Ji%c%",
		"You only remember one thing:", # You need to press %cJc% to interact.\t\t %c%iPress Ji%c%
		#"Oh, and you remember one other thing:",
		"%cYOU NEED TO GET RICH.%c"
	]
	for i in exposition.size():
		exposition[i] = exposition[i].replace("%i", "[i]").replace("i%", "[/i]")
		exposition[i] = exposition[i].replace("%c", "[color=orange]").replace("c%", "[/color]")
	exposition_i = 0
	get_node(Paths.dialogue_box).visible = true
	get_node(Paths.dialogue_label).text = exposition[exposition_i]

func interaction() -> void:
	if (interactor != noInteractor):
		set_process_unhandled_key_input(false)
		get_node(Paths.player).set_physics_process(false)
		interactor.interact()

func end_interact() -> void:
	set_process_unhandled_key_input(true)
	get_node(Paths.player).set_physics_process(true)
	
func update_stonks(update: float) -> void:
	stonks += update
	get_node(Paths.stonks).text = "stonks: " + str(stonks)

func update_stonks_ci(lower_bound: float, upper_bound: float, solution: float, stakes: float) -> void: #TODO: correct scoring rule
	if ((lower_bound <= solution) and (upper_bound >= solution)):
		update_stonks(stakes)

func update_stonks_multiple_choice(is_correct: bool, confidence: float, stakes: float) -> void: #TODO: correct scoring rule
	if is_correct:
		update_stonks(stakes)

func _on_npc_interactable(npc: StaticBody2D) -> void:
	interactor = npc
func _on_npc_not_interactable(npc: StaticBody2D) -> void:
	if interactor == npc:
		interactor = noInteractor
