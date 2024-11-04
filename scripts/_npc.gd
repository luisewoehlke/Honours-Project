extends StaticBody2D

signal interactable
signal not_interactable

class Problem:
	var text: String
	var stakes: float
class MultipleChoice extends Problem:
	var options: Array[String]
	var solution: String
	func _init(text: String, options: Array[String], solution: String, stakes: float) -> void:
		self.text = text
		self.options = options
		self.solution = solution
		self.stakes = stakes
class CI extends Problem:
	var solution: float
	func _init(text: String, solution: float, stakes: float) -> void:
		self.text = text
		self.solution = solution
		self.stakes = stakes

enum states { NONE, TALK, PROBLEM }
var state: states = states.NONE
var problems: Array[Problem]
var talk: Array
var talk_i: int = 0

func _ready() -> void:
	set_process_unhandled_key_input(false)
	add_to_group("NPCs")
	initialize_talk()
	
	for i in talk.size():
		if (talk[i] is String):
			talk[i] = talk[i].replace("%c", "[color=orange]").replace("c%", "[/color]")

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("j"):
		if state == states.TALK:
			progress_talk()
		elif state == states.PROBLEM:
			pass # j does nothing in problem screen

func progress_talk() -> void:
	talk_i += 1
	if is_talk_done():
		end_interact()
	elif talk[talk_i] is Problem:
		state = states.PROBLEM
		open_ci_problem() if (talk[talk_i] is CI) else open_multiple_choice_problem()
	elif talk[talk_i] is String:
		state = states.TALK
		var label = get_node(Paths.dialogue_label)
		label.text = talk[talk_i]
	elif talk[talk_i] is Callable:
		talk[talk_i].call()
	else:
		push_error()

func initialize_talk() -> void:
	pass

func is_talk_done() -> bool:
	return (talk_i >= talk.size())

func setup_multiple_choice_fields() -> void:
	var problem: MultipleChoice = talk[talk_i]
	var items_node = get_node(Paths.multiple_choice_items)
	var confidence_buttons = items_node.get_node("ConfidenceButtons").get_children()
	
	items_node.get_node("Error").text = ""
	for i in [1,2,3,4]:
		items_node.get_node("Option"+str(i)).visible = false
		items_node.get_node("Option"+str(i)).button_pressed = false
	for i in problem.options.size():
		items_node.get_node("Option" + str(i+1)).text = problem.options[i]
		items_node.get_node("Option" + str(i+1)).visible = true
	for button_node in confidence_buttons:
		button_node.button_pressed = false

func open_multiple_choice_problem() -> void:
	var problem: MultipleChoice = talk[talk_i]
	var tab_node = get_node(Paths.multiple_choice_tab)
	var items_node = get_node(Paths.multiple_choice_items)
	
	get_node(Paths.problem).visible = true
	get_node(Paths.ci_tab).visible = false
	tab_node.visible = true
	items_node.get_node("Question").text = problem.text
	setup_multiple_choice_fields()
	items_node.get_node('ProblemTimer').time()

func open_ci_problem() -> void:
	var problem: CI = talk[talk_i]
	get_node(Paths.problem).visible = true
	get_node(Paths.multiple_choice_tab).visible = false
	get_node(Paths.ci_tab).visible = true
	get_node(Paths.ci_items + "/Question").text = problem.text
	get_node(Paths.ci_items + "/ProblemTimer").time()

func ci_submit(lower_bound: float, upper_bound: float):
	var question_node = get_node(Paths.solution_items + "/Question")
	var correctness_node = get_node(Paths.solution_items + "/Correct?")
	var solution_node = get_node(Paths.solution_items + "/Solution")
	var solution_confidence_node = get_node(Paths.solution_items + "/Confidence")
	var problem: CI = talk[talk_i]
	question_node.text = problem.text
	solution_node.text = "Correct answer: " + str(problem.solution)		
	
	if is_nan(lower_bound): # if timeout
		correctness_node.text = "Timeout\n"
		solution_confidence_node.text = ""	
	else:		
		var is_correct : bool = ((problem.solution >= lower_bound) and (problem.solution <= upper_bound))
		get_node("/root/Game").update_stonks_ci(lower_bound, upper_bound, problem.solution, problem.stakes)
		correctness_node.text = "Correct!\n" if is_correct else "Incorrect.\n"
		solution_confidence_node.text = "Your 80% Confidence Interval: " + str(lower_bound) + " - " + str(upper_bound)
	
	get_node(Paths.ci_tab).visible = false
	get_node(Paths.solution_tab).visible = true

func multiple_choice_submit(answer: String, confidence: float):
	var question_node = get_node(Paths.solution_items + "/Question")
	var correctness_node = get_node(Paths.solution_items + "/Correct?")
	var solution_node = get_node(Paths.solution_items + "/Solution")
	var solution_confidence_node = get_node(Paths.solution_items + "/Confidence")
	var problem: MultipleChoice = talk[talk_i]	
	question_node.text = problem.text
	solution_node.text = "Correct answer: " + str(problem.solution)
	
	if is_nan(confidence): # if timeout
		correctness_node.text = "Timeout\n"
		solution_confidence_node.text = ""
		solution_node.visible = true
	else:		
		var is_correct : bool = problem.solution == answer
		get_node("/root/Game").update_stonks_multiple_choice(is_correct, confidence, problem.stakes)
		
		correctness_node.text = "Correct!\n" if is_correct else "Incorrect.\n"
		if is_correct:
			solution_node.visible = false
		else:
			solution_node.visible = true
		solution_confidence_node.text = "Your Confidence Level: " + str(confidence) + "%"
		
	get_node(Paths.multiple_choice_tab).visible = false
	get_node(Paths.solution_tab).visible = true
		
func exit_problem() -> void:
	get_node(Paths.problem).visible = false
	progress_talk()

func end_interact() -> void: # when problem was already solved
	set_process_unhandled_key_input(false)
	get_node(Paths.problem).visible = false	
	var dialogueBox = get_node(Paths.dialogue_box)	
	dialogueBox.visible = false
	state = states.NONE
	get_node("/root/Game").end_interact()
	
func interact() -> void:	# currently interactions always have to
	# start with a talk item
	var label = get_node(Paths.dialogue_label)
	
	if is_talk_done():
		label.text = "You've already solved my problems."
	else:
		label.text = talk[0]
	get_node(Paths.dialogue_box).visible = true
	state = states.TALK
	set_process_unhandled_key_input(true)

func _on_area_2d_body_entered(body: Node2D) -> void:
	emit_signal("interactable", self)
func _on_area_2d_body_exited(body: Node2D) -> void:
	emit_signal("not_interactable", self)
