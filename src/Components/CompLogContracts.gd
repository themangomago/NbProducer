extends Control


var artist = null

func setup(node):
	artist = node
	var data = node.character
	#print(data.name)
	$LPersona.set_text(data.name + ", " + data.gender + str(data.age))
	
	if not node.contract.signed:
		$LCosts.set_text("Costs: $" + str(node.contract.salary) + "/week of work")
	else:
		$LCosts.set_text("Salary: $" + str(node.contract.salary) + "/week")
	$Skills/LSkill1/CompStar.setStars(data.skills.keyboard)
	$Skills/LSkill2/CompStar.setStars(data.skills.guitar)
	$Skills/LSkill3/CompStar.setStars(data.skills.bass)
	$Skills/LSkill4/CompStar.setStars(data.skills.drummer)
	$Skills/LSkill5/CompStar.setStars(data.skills.texter)
	$Skills/LSkill6/CompStar.setStars(data.skills.mixer)
	
	if node.contract.duration <= 1 and node.contract.signed:
		$BtnExtend.show()
	else:
		$BtnExtend.hide()


func _on_BtnSign_button_up():
	Global.GI.LogGui.jobsSign(artist)
	queue_free()


func _on_BtnDelete_button_up():
	Global.GI.LogGui.jobsDelete(artist)
	queue_free()


func _on_BtnFire_button_up():
	Global.GI.LogGui.fireArtist(artist)
	queue_free()

func _on_BtnExtend_button_up():
	artist.contract.duration += 2
	artist.contract.salary *= 1.1
	Global.GI.Notification.notify(artist.character.name + "s contract extended for 2yrs and +10% salary", "HR")
	
