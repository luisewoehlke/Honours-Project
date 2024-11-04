extends Node2D

var stonks: float = 0
var noInteractor: Node2D = Node2D.new()
var interactor: Node2D = noInteractor
enum states {OVERLAY, GAME}
var state: states = states.OVERLAY
var overlay_talk: Array[String]
var overlay_i: int

var exposition: Array[String] = [
		"You wake up on an empty street. Your head hurts. You remember NOTHING.\t\t {%iPress Ji%}",
		"Where are you? Why are you a knight?? Your name???\t\t {%iPress Ji%}",
		"You decide to call yourself {LORD RUDOLPHUS II} from now on.\t\t {%iPress Ji%}",
		"You only remember one thing:", # You need to press {J} to interact.\t\t {%iPress Ji%}
		#"Oh, and you remember one other thing:",
		"{YOU NEED TO GET RICH.}"
	]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	overlay(exposition)

func setup_interactable_signal(npc: StaticBody2D) -> void:
	npc.connect("interactable", _on_npc_interactable)
	npc.connect("not_interactable", _on_npc_not_interactable)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("j"):
		if state == states.OVERLAY:
			progress_overlay()
		elif state == states.GAME:
			interaction()

func progress_overlay() -> void:
	overlay_i += 1
	if overlay_i == overlay_talk.size():
		state = states.GAME
		get_node(Paths.dialogue_box).visible = false
		get_node(Paths.player).set_physics_process(true)
	else:
		var label = get_node(Paths.dialogue_label)
		label.text = overlay_talk[overlay_i]

func overlay(talk: Array[String]) -> void:
	state = states.OVERLAY
	get_node(Paths.player).set_physics_process(false)
	for i in talk.size():
		talk[i] = talk[i].replace("%i", "[i]").replace("i%", "[/i]")
		talk[i] = talk[i].replace("{", "[color=orange]").replace("}", "[/color]")
	overlay_i = 0
	overlay_talk = talk
	get_node(Paths.dialogue_box).visible = true
	get_node(Paths.dialogue_label).text = overlay_talk[overlay_i]

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
