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
		"Oh, I'm so glad you're here! I'm %cDorothyc%. I need your help!",
		"I have this modern telephone here: A Nokia-3310!! I don't know how to operate such cutting-edge technology.",
		"%cI accidentally deleted the interweb!!c%",
		"Look, the internet icon is completely %cgone from my displayc%!! What will all the young people do now without mySpace?",
		"Say, can you help me?",
		problems[0],
		"Ohhh, what would I do without you! But it's so rude of me not to ask your name. Tell me, who are you my dear?",
		"…",
		"%cLord Rudolphus IIc% you say… Getting rich you say… Well, then you should go to %cMULTILEVEL MONEYMAKERS LLCc%. You will need some starting capital. Here…",
		"%cLord Rudolphus IIc% obtained %c25pc%!",
		"Now it's morning and they should open soon. Good luck!",
	]
