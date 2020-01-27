extends Control

var node = null

func _ready():
	var data = Data.generateNameAndGender()
	var loop = true
	while(loop):
		data = Data.generateNameAndGender()
		if data.gender != "w":
			loop = false
	$TextEdit.text = data.name

func updateGui():
	randomChar()

func randomChar():
	if node:
		node.queue_free()
	node = Global.GI.ArtistFactory.newArtist(0)
	node.character.skills.texter = randi()%8 + 1
	node.character.skills.keyboard = randi()%8 + 1
	node.character.name = $TextEdit.text
	$BarKeyboard.setup("Keyboard" , node.character.skills.keyboard)
	$BarGuitar.setup("Guitar" , node.character.skills.guitar)
	$BarBass.setup("Bass" , node.character.skills.bass)
	$BarDrummer.setup("Drummer" , node.character.skills.drummer)
	$BarTexter.setup("Texter" , node.character.skills.texter)
	$BarMixer.setup("Mixer" , node.character.skills.mixer)
	$BarMotivation.setup("Motivation" , node.character.motivation)
	$BarTalent.setup("Talent" , node.character.talent)


func _on_BtnAccept_button_up():
	Global.GI.Player.character = node.character
	Global.GI.lockPlayer = false
	Global.GI.get_node("UI/Bg").hide()
	hide()


func _on_BtnRandomize_button_up():
	Global.GI.Balance.cash -= 500
	randomChar()
