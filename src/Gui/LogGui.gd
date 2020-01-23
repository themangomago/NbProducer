extends Control




onready var CompLogJob = preload("res://src/Components/CompLogJobApplication.tscn")
onready var CompLogContract = preload("res://src/Components/CompLogContracts.tscn")


func addDiary(string, origin):
	print("diary added")
	print(string)
	Data.diary.push_front({"string": string, "origin": origin, "week": Global.GI.Week.week})

func updateDiary():
	$Diary/TeDiary.text = "MEMO:\n"
	
	for entry in Data.diary:
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
	for node in $Contracts/Vpage1.get_children():
		node.queue_free()
	for node in $Contracts/Vpage2.get_children():
		node.queue_free()
	
	if Global.GI.Company.get_child_count() > 0:
		var count = 0
		$Contracts/LContract.hide()
		for artists in Global.GI.Company.get_children():
			var node = CompLogContract.instance()
			node.setup(artists)
			count += 1
			
			if count < 5:
				$Contracts/Vpage1.add_child(node)
			else:
				$Contracts/Vpage2.add_child(node)
	else:
		$Contracts/LContract.show()

func clear():
	$Diary.hide()
	$Contracts.hide()
	$Jobs.hide()

func jobsDelete(artist):
	artist.queue_free() 
	$Timer.start() #Delete GuiUpdate

func jobsSign(artist):
	if Global.GI.checkAp(Data.AP_COST_LOG_HIRE, "HR"):
		Global.GI.decAp(Data.AP_COST_LOG_HIRE)
		Global.GI.Applications.remove_child(artist)
		Global.GI.Company.add_child(artist)
		Global.GI.Notification.notify("Artist " + artist.character.name + " is now available.", "HR")

func fireArtist(artist):
	artist.queue_free()
	$Timer.start() 

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
			updateContracts()
		_: #Jobs
			updateJobs()
