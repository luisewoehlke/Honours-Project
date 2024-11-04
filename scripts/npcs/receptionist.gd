extends "res://scripts/_npc.gd"

func initialize_talk() -> void:
	talk = [
		"Welcome to {MULTILEVEL MONEYMAKERS}. Wowow, what a great starting capital!",
		"You must've gotten a great return of {£1,000} because you gave a {high confidence level} with your answer.",
		"When you are confident, that means you can invest more, leading to {more returns}.",
		"But when you are confidently wrong, then you can {lose more money}.",
		"So it is important to {learn to choose the right confidence level}.",
		"Remember this: A confidence level of 50% means you should be right 50% of the time, no more, no less.",
		"A confidence level of 90% means you should be right 90% of the time and so on.",
		"Good luck!",
		open_gate,
	]
	re_talk = "Good luck!"

func open_gate() -> void:
	var tilemap = get_node(Paths.tilemap_level0)
	tilemap.set_cell(Vector2(0, 8), -1)
	
	progress_talk()
