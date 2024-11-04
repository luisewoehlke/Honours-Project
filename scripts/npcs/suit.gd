extends "res://scripts/_npc.gd"

# Called when the node enters the scene tree for the first time.
func initialize_talk() -> void:
	problems = [
		MultipleChoice.new(
			"Which company manufactures microprocessors?",
			["Intel", "Lidl"],
			"Intel",
			0
		)
	]
	talk = [
		"Bugger off, hobo. I'm VERY important. I make %cinvestmentsc% in VERY important computer processors.",
		"And of course I DO remember which of these company makes processors and I don't need your help at all...",
		"Wait! This is a test!! Tell me…",
		problems[0],
		"Intel was right… Which I KNEW of course!!",
		"So Lidl is a discounter supermaket chain? How should I know?? Do I look like I do my own shopping??",
		"Alright, I'll give you the returns of the investment if you don't tell a soul about this exchange.",
		give_roi,
		"%cLord Rudolphus IIc% obtained %c£100c%!"
	]

func give_roi() -> void:
	get_node("/root/Game").update_stonks(1000)
	get_node(Paths.stonks).visible = true
	progress_talk()
	
	
	
	
	
	
	
	
	
