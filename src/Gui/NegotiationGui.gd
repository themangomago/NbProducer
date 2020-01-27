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

var albums = 0
var salary = 0
var artistAlbums = 0
var artistSalary = 0
var happiness = 5

var talentNode = null
var signed = false

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
	talentNode = talent
	# Notes
	var atmosphere = int((talent.character.talent * 2 + talent.character.skills.singer * 3 + talent.character.skills.texter)/6)
	var popularity = int((talent.character.talent + talent.character.popularity * 3 + talent.character.charisma * 2)/6)
	
	var skill1 = randomTalent(talent)
	var skill2 = randomTalent(talent)
	
	while (skill1.name == skill2.name):
		skill2 = randomTalent(talent)

	$Atmosphere.setup("Atmosphere", atmosphere)
	$Popularity.setup("Popularity", popularity)
	$Random1.setup(skill1.name, skill1.value)
	$Random2.setup(skill2.name, skill2.value)
	
	# Contract
	albums = randi() % 3 + 1
	artistAlbums = albums
	salary = Data.calculateSalary(talent) 
	artistSalary = salary + randi() % 200
	updateNegotiation()

	# Id Card
	$LabelName.set_text(talent.character.name)
	$LabelAge.set_text(str(talent.character.age))
	$LabelGender.set_text(talent.character.gender)
	
	$Bar.setup("Happiness", happiness)

func updateNegotiation():
	$Albums/Artist.set_text(str(artistAlbums))
	$Albums/You.set_text(str(albums))
	$Money/Artist.set_text(str(artistSalary))
	$Money/You.set_text(str(salary))
	$Bar.setValue(happiness)
	
func _Album_on_Dec_button_up():
	albums = max(1, albums - 1)
	$Albums/You.set_text(str(albums))


func _Album_on_Inc_button_up():
	albums = min(5, albums + 1)
	$Albums/You.set_text(str(albums))


func _Salary_on_Dec_button_up():
	salary = max(salary - 50, salary - 10)
	$Money/You.set_text(str(salary))


func _Salary_on_Inc_button_up():
	salary = min(artistSalary + 50, salary + 10)
	$Money/You.set_text(str(salary))



#var contract = {
#	"signed": false,
#	"duration": 0,
#	"relationship": 0,
#	"salary": 0
#}

func _on_BtnNegotiate_button_up():
	if signed:
		Global.click()
		talentNode.contract.signed = true
		talentNode.contract.duration = albums
		talentNode.contract.relationship = min(happiness + 2, 10)
		talentNode.contract.salary = salary
		print(talentNode.contract)
		Global.GI.hireTalent(talentNode)
		_on_BtnClose_button_up()
		return
		
	if albums != artistAlbums:
		if albums > artistAlbums:
			artistSalary = int(1.1 * artistSalary)
			artistAlbums += 1
			happiness += 1
		else:
			artistAlbums -= 1
			happiness -= 1

	if salary != artistSalary:
		if salary > artistSalary:
			happiness += 1
			if salary > artistSalary * 1.05:
				happiness += 1
			if salary > artistSalary * 1.1:
				happiness += 1
			artistSalary = salary
		else:
			if salary < artistSalary * 0.9:
				happiness -= 1
			artistSalary -= 5
	
	happiness -= 1
	
	if happiness <= 0:
		$BtnNegotiate.disabled = true
		$BtnNegotiate.text = "Cancelled.."
	if salary == artistSalary and albums == artistAlbums:
		talentNode.character.motivation = min(talentNode.character.motivation + 1, 10)
		signed = true
		$BtnNegotiate.text = "Sign Contract"
		

	updateNegotiation()


func _on_BtnClose_button_up():
	get_parent().closeActive()
