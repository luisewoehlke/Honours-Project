extends "res://scripts/_npc.gd"

func initialize_talk() -> void:
	problems = [
		MultipleChoice.new(
			"Which among the following is an application of Generative AI?",
			["Producing realistic video game characters", "The Youtube recommendations algorithm"],
			"Producing realistic video game characters",
			1000
		)
	]
	talk = [
		"Hey hotshot! You think you're pretty cool with {£1,000}, huh? But you will NEVER make it.",
		"I will make it out of the lobby soon and join the big players on {first floor}.",
		"I've just got to make some dough quick by investing in the hot new stuff—{Generative AI}.",
		"Blimey, if only I knew what that actually is…",
		problems[0],
		"I will be on {first floor} soon but I don't suppose I will see you there, Lordling. So long, hotshot!",
		move_to_lift,		
		"You feel the need to get rich getting stronger.",
		"All you need MONEY. All you can think about is DOUGH. The need to be rich is OVERWHELMING.",
	]
	re_talk = "I will be on {first floor} soon but I don't suppose I will see you there, Lordling. So long, hotshot!"
	
func move_to_lift() -> void:
	position = Vector2(8,16)
	progress_talk()
