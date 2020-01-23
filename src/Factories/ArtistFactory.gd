extends Node

var artistScene = load("res://src/Persons/Artist.tscn")


func newSinger():
	var new = artistScene.instance()
	var id = Data.generateNameAndGender()
	
	randomize()
	
	var data = {
		"charisma": randi()%10 + 1,
		"motivation": randi()%10 + 1,
		"talent": randi()%10 + 1,
		"popularity": randi()%4 + 1,
	}
	
	var skills = {
		"singer": max(5, randi()%10 + 1),
		"keyboard":randi()%5 + 1,
		"guitar": randi()%6 + 1,
		"bass": randi()%4 + 1,
		"drummer": randi()%4 + 1,
		"texter": randi()%10 + 1,
		"mixer": randi()%6 + 1,
	}
	   #createPerson(pName, age, gender, skills, charisma, motivation, talent, popularity)
	new.createPerson(id.name, int(rand_range(18,44)), id.gender, skills, data.charisma, data.motivation, data.talent, data.popularity)
	#print(Data.calculateSalary(new))
	return new


func newArtist(type):
	var node = newSinger()

	node.character.skills.singer = randi()%5 + 1
	node.character.skills.texter = randi()%5 + 1


	if type == 0:
		type = randi()%6 + 1

	match type:
		1: # $PJob/ObAdvertise.add_item("Specific: Keyboard")
			node.character.skills.keyboard = max(5, randi()%10 + 1)
		2: # $PJob/ObAdvertise.add_item("Specific: Guitar")
			node.character.skills.guitar = max(5, randi()%10 + 1)
		3: # $PJob/ObAdvertise.add_item("Specific: Bass")
			node.character.skills.bass = max(5, randi()%10 + 1)
		4: # $PJob/ObAdvertise.add_item("Specific: Drum")
			node.character.skills.drummer = max(5, randi()%10 + 1)
		5: # $PJob/ObAdvertise.add_item("Specific: Texter")
			node.character.skills.texter = max(5, randi()%10 + 1)
		_: # $PJob/ObAdvertise.add_item("Specific: Mixer")
			node.character.skills.mixer = max(5, randi()%10 + 1)

	return node

