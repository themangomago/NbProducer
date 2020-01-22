extends Control


var diary = []


onready var CompLogJob = preload("res://src/Components/CompLogJobApplication.tscn")



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
	_on_BtnMemo_button_up()

func updateJobs():
	for node in $Jobs/Vpage1.get_children():
		node.queue_free()
	for node in $Jobs/Vpage2.get_children():
		node.queue_free()
	
	if Global.GI.Applications.get_child_count() > 0:
		var count = 0
		$Jobs/LJobs.hide()
		for artists in Global.GI.Applications.get_children():
			var node = CompLogJob.instance()
			node.setup(artists)
			count += 1
			
			if count < 5:
				$Jobs/Vpage1.add_child(node)
			else:
				$Jobs/Vpage2.add_child(node)
	else:
		$Jobs/LJobs.show()

func updateContracts():
	pass

func clear():
	$Diary.hide()
	$Contracts.hide()
	$Jobs.hide()

func jobsDelete(artist):
	artist.queue_free() 
	$Timer.start() #Delete GuiUpdate

func jobsSign(artist):
	Global.GI.Applications.remove_child(artist)
	Global.GI.Company.add_child(artist)
	Global.GI.Notification.notify("Artist " + artist.character.name + " is now available.", "HR")

func _on_BtnJobs_button_up():
	clear()
	updateJobs()
	$Jobs.show()
	$Bg.frame = 2

func _on_BtnContracts_button_up():
	clear()
	updateContracts()
	$Contracts.show()
	$Bg.frame = 1

func _on_BtnMemo_button_up():
	clear()
	updateDiary()
	$Diary.show()
	$Bg.frame = 0


func _on_Timer_timeout():
	match $Bg.frame:
		0: #Memo
			pass
		1: #Contracts
			pass
		_: #Jobs
			updateJobs()
