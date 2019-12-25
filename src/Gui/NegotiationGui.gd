extends Control


# alben anzahl: je weniger talent umso mehr platten
#
#		"singer": 2,
#		"keyboard": 4,
#		"guitar": 0,
#		"bass": 5,
#		"drummer": 2,
#		"texter": 4,
#		"mixer": 3

func randomTalent(talent):
	var random = randi() % 7
	var skillName
	var value
	
	match random:
		0:
			skillName = "Singer"
			value = talent.character.skills.singer
		1:
			skillName = "Keyboard"
			value = talent.character.skills.keyboard
		2:
			skillName = "Guitar"
			value = talent.character.skills.guitar
		3:
			skillName = "Bass"
			value = talent.character.skills.bass
		4:
			skillName = "Drummer"
			value = talent.character.skills.drummer
		5:
			skillName = "Texter"
			value = talent.character.skills.texter
		_:
			skillName = "Mixer"
			value = talent.character.skills.mixer
	return {"name": skillName, "value": value}


func setArtist(talent):
	var atmosphere = int((talent.character.talent * 2 + talent.character.skills.singer * 3 + talent.character.skills.texter)/6)
	var popularity = int((talent.character.talent + talent.character.popularity * 3 + talent.character.charisma * 2)/6)
	
	var skill1 = randomTalent(talent)
	var skill2 = randomTalent(talent)
	
	while (skill1.name == skill2.name):
		skill2 = randomTalent(talent)

	$Notes/Atmosphere.setup("Atmosphere", atmosphere)
	$Notes/Popularity.setup("Popularity", popularity)
	$Notes/Random1.setup(skill1.name, skill1.value)
	$Notes/Random2.setup(skill2.name, skill2.value)
	
	var albums = randi() % 3 + 1
	$Contract/Albums/Artist.set_text(str(albums))
	$Contract/Albums/You.set_text(str(albums))
	var salary = Data.calculateSalary(talent) 
	$Contract/Money/Artist.set_text(str(salary + randi() % 200))
	$Contract/Money/You.set_text(str(salary))

func _Album_on_Dec_button_up():
	pass # Replace with function body.


func _Album_on_Inc_button_up():
	pass # Replace with function body.


func _Salary_on_Dec_button_up():
	pass # Replace with function body.


func _Salary_on_Inc_button_up():
	pass # Replace with function body.
