extends Control


var artist = null
var costs = 0

func setup(node):
	artist = node
	var data = node.character
	#print(data.name)
	$LPersona.set_text(data.name + ", " + data.gender + str(data.age))
	
	costs = Data.calculateSalary(artist) / 2
	$LCosts.set_text("Costs: $" + str(costs) + "/week of work")
	node.contract.salary = costs
	$Skills/LSkill1/CompStar.setStars(data.skills.keyboard)
	$Skills/LSkill2/CompStar.setStars(data.skills.guitar)
	$Skills/LSkill3/CompStar.setStars(data.skills.bass)
	$Skills/LSkill4/CompStar.setStars(data.skills.drummer)
	$Skills/LSkill5/CompStar.setStars(data.skills.texter)
	$Skills/LSkill6/CompStar.setStars(data.skills.mixer)


func _on_BtnSign_button_up():
	Global.GI.LogGui.jobsSign(artist)
	queue_free()


func _on_BtnDelete_button_up():
	Global.GI.LogGui.jobsDelete(artist)
	queue_free()
