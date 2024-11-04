extends "res://scripts/_npc.gd"

# Called when the node enters the scene tree for the first time.
func initialize_talk() -> void:
	problems = [
		MultipleChoice.new(
			"Has Dorothy deleted the internet from planet earth?",
			["Yes", "No"],
			"No",
			0
		),
	]
	talk = [
		"Oh, I'm so glad you're here! I'm {Dorothy}. I need your help!",
		"I have this modern telephone here: A Nokia-3310!! I don't know how to operate such cutting-edge technology.",
		"{I accidentally deleted the interweb!!}",
		"Look, the internet icon is completely {gone from my display}!! What will all the young people do now without mySpace?",
		"Say, can you help me?",
		problems[0],
		"Ohhh, what would I do without you! But it's so rude of me not to ask your name. Tell me, who are you my dear?",
		"…",
		"{Lord Rudolphus II} you say… Getting rich you say… Well, then you should go to {MULTILEVEL MONEYMAKERS LLC}.",
		"You will need a starting capital around £1,000. Here…",
		"{Lord Rudolphus II} obtained {25p}!",
		"Now it's morning and they should open soon. Good luck!",
		setup_morning,
	]
	
func setup_morning() -> void:
	var suit_node = load("res://scenes/npcs/suit.tscn").instantiate()
	get_node(Paths.level_street).add_child(suit_node)
	suit_node.position = Vector2(128,80)
	var bouncer_node = load("res://scenes/npcs/bouncer.tscn").instantiate()
	get_tree().root.add_child(bouncer_node)
	bouncer_node.position = Vector2(40,0) #48,0
	
	progress_talk()
	
	
	
	
	
