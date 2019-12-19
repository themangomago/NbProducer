extends Node


var counter = 1


func generateNameAndGender():
	var gName = "Test"+str(counter)
	counter += 1
	var gGender = "w"
	if counter % 2:
		gGender = "m"
	
	return {"name": gName, "gender": gGender }



func calculateSalary(talent):
	var salaray = talent.character.charisma * talent.character.popularity * 3 + talent.character.motivation * talent.character.talent * talent.character.skills.singer * 4
	return salaray
	
	
