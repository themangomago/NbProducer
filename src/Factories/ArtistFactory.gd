extends Node

var artistScene = load("res://src/Persons/Artist.tscn")


func _ready():
	pass # Replace with function body.


func newSinger():
	var new = artistScene.instance()
	var id = Data.generateNameAndGender()
	
	randomize()
	
	var data = {
		"charisma": randi()%10 + 1,
		"motivation": randi()%10 + 1,
		"talent": randi()%10 + 1,
		"popularity": randi()%10 + 1,
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
	new.createPerson(id.name, min(18, randi()%100 + 1), id.gender, skills, data.charisma, data.motivation, data.talent, data.popularity)
	print(Data.calculateSalary(new))
	return new
