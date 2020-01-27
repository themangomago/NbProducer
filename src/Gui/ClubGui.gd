extends Control

var person = null

func setArtist(talent):
	
	var label = talent.character.name + ", " + str(talent.character.age)+ " years, " + talent.character.gender
	$Panel/Label.set_text(label)

	var atmosphere = int((talent.character.talent * 2 + talent.character.skills.singer * 3 + talent.character.skills.texter)/6)
	var popularity = int((talent.character.talent + talent.character.popularity * 3 + talent.character.charisma * 2)/6)
	
	$Panel/Atmosphere.setup("Atmosphere", atmosphere)
	$Panel/Popularity.setup("Popularity", popularity)

	person = talent


func _on_Button_button_up():
	Global.GI.negotiateTalent(person)
	Global.click()


func _on_BtnClose_button_up():
	get_parent().closeActive()
