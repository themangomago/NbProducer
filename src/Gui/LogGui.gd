extends Control


var diary = []




# Called when the node enters the scene tree for the first time.
func _ready():
	#$Diary/TeDiary.set("custom_colors/font_color",Color(1,0,0))
	diary = []


func addDiary(string, origin):
	print("diary added")
	print(string)
	diary.push_front({"string": string, "origin": origin, "week": Global.GI.Week.week})

func updateDiary():
	$Diary/TeDiary.text = "MEMO:\n"
	
	for entry in diary:
		$Diary/TeDiary.text += entry.origin + ": " + entry.string + " (Week: " + str(entry.week) + ")\n"


func updateGui():
	updateDiary()
	_on_BtnLogbook_button_up()

func clear():
	$Diary.hide()

func _on_BtnLogbook_button_up():
	$Diary.show()


func _on_BtnJobs_button_up():
	pass # Replace with function body.


func _on_BtnContracts_button_up():
	pass # Replace with function body.
