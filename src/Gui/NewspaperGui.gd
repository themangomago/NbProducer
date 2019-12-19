extends Control

func setArtists(club1, club2, club3):
	$Label.set_text(club1)
	$Label2.set_text(club2)
	$Label3.set_text(club3)
	


func _on_BtnClose_button_up():
	get_parent().closeActive()


func _on_BtnClub1_button_up():
	Global.GI.scoutClub(0)


func _on_BtnClub2_button_up():
	Global.GI.scoutClub(1)


func _on_BtnClub3_button_up():
	Global.GI.scoutClub(2)
