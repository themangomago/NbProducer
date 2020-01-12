extends Node


var counter = 1

const AP_COST_VISIT_CONCERT = 5
const AP_COST_NEGOTIATION = 3
const AP_COST_COMPOSE = 10
const AP_COST_SELF_TRAINING = 10
const AP_COST_TRAINING = 1
const AP_COST_JOB = 1
const AP_COST_BANK = 3

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
	
	
