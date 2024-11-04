extends CanvasLayer

func _on_exit_button_pressed() -> void:
	var interactor = get_node("/root/Game").interactor
	interactor.exit_problem()
	
func ci_submit() -> void:
	if ci_input_validation():
		var interactor = get_node("/root/Game").interactor
		var lower_bound = get_node(Paths.ci_items +'/CILowerBound').text
		var upper_bound = get_node(Paths.ci_items +'/CIUpperBound').text
		var timer_node = get_node(Paths.ci_items + "/ProblemTimer")
		timer_node.cancel()
		interactor.ci_submit(float(lower_bound), float(upper_bound))

func ci_input_validation() -> bool:
	var lower_bound = get_node(Paths.ci_items +'/CILowerBound').text
	var upper_bound = get_node(Paths.ci_items +'/CIUpperBound').text
	var error_node = get_node(Paths.ci_items + "/Error")
	
	var valid: bool = lower_bound.is_valid_int() and upper_bound.is_valid_int()
	if not valid:
		error_node.text = "Your lower and upper bounds have to be integers."
	return valid

func ci_timeout() -> void:	
	var interactor = get_node("/root/Game").interactor
	interactor.ci_submit(NAN, NAN)

func get_multiple_choice_confidence() -> float:
	var confidence_button_nodes = get_node(Paths.multiple_choice_items + "/ConfidenceButtons").get_children()
	var confidence = NAN
	var confidence_text: String
	
	for confidence_button_node in confidence_button_nodes:
		if confidence_button_node.button_pressed:
			confidence_text = confidence_button_node.text
			confidence = float(confidence_text.substr(0, confidence_text.length() - 1))
	return confidence

func get_multiple_choice_answer() -> String:
	var option_nodes = [
		get_node(Paths.multiple_choice_items + "/Option1"),
		get_node(Paths.multiple_choice_items + "/Option2"),
		get_node(Paths.multiple_choice_items + "/Option3"),
		get_node(Paths.multiple_choice_items + "/Option4")
	]
	var answer = ""
	for option_node in option_nodes:
		if option_node.button_pressed:
			answer = option_node.text
	return answer

func multiple_choice_submit() -> void:	
	var interactor = get_node("/root/Game").interactor
	var confidence: float = get_multiple_choice_confidence()
	var answer: String = get_multiple_choice_answer()
	var timer_node = get_node(Paths.multiple_choice_items + "/ProblemTimer")
	var confidence_text: String
	
	if multiple_choice_input_validation(answer, confidence):
		timer_node.cancel()
		interactor.multiple_choice_submit(answer, confidence)

func multiple_choice_input_validation(answer: String, confidence: float) -> bool:
	var error_node = get_node(Paths.multiple_choice_items + "/Error")	
	var valid: bool = (answer != "") and (not is_nan(confidence))
	if not valid:
		error_node.text = "Please select an option and a confidence level."
	return valid
	
func multiple_choice_timeout() -> void:	
	var interactor = get_node("/root/Game").interactor
	interactor.multiple_choice_submit("", NAN)
	
func _on_ci_submit_button_pressed() -> void:
	ci_submit()
func _on_multiple_choice_submit_button_pressed() -> void:
	multiple_choice_submit()
