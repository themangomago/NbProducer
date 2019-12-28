extends Node

var character = {
	"name": "test",
	"age": 24,
	"gender": "m",
	"skills": {
		"singer": 2,
		"keyboard": 4,
		"guitar": 0,
		"bass": 5,
		"drummer": 2,
		"texter": 4,
		"mixer": 3
	},
	"charisma": 5,
	"motivation": 3,
	"talent": 10,
	"popularity": 4,
}

var contract = {
	"signed": false,
	"duration": 0,
	"relationship": 0,
	"salary": 0
}



func createPerson(pName, age, gender, skills, charisma, motivation, talent, popularity):
	character.name = pName
	character.age = age
	character.gender = gender
	character.charisma = charisma
	character.motivation = motivation
	character.talent = talent
	character.popularity = popularity
	character.skills.singer = skills.singer
	character.skills.keyboard = skills.keyboard
	character.skills.guitar = skills.guitar
	character.skills.bass = skills.bass
	character.skills.drummer = skills.drummer
	character.skills.texter = skills.texter
	character.skills.mixer = skills.mixer
	
	print("Created: " + str(character.name) + "\n" + str(character) )
	



