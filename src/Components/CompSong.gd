extends Control

var assignedNode = null

func setup(node):
	if node.data.onAlbum:
		$BtnToAlbum.hide()
		$IconMove.hide()

	$LSong.set_text(node.data.title)
	
	if node.data.ready:
		$CompStar.setStars(node.data.quality)
		
		print(node.data.duration)
		var duration =  str(int(node.data.duration/60)) + ":%0*d" % [2, node.data.duration - int(node.data.duration/60)*60]
		$LLength.set_text(duration + "m")
	else:
		$CompStar.setStars(0)
		$LLength.set_text("")
		$BtnToAlbum.disabled = true
		$BtnDelete.disabled = true
		$IconDelete.frame = 2
		$IconMove.frame = 2
	assignedNode = node
	



func _on_BtnToAlbum_button_up():
	assignedNode.data.onAlbum = true
	get_parent().get_parent().updateGui()


func _on_BtnDelete_button_up():
	get_parent().get_parent().removeSong(assignedNode)


func _on_BtnDelete_mouse_entered():
	if not $BtnDelete.disabled:
		$IconDelete.frame = 1

func _on_BtnDelete_mouse_exited():
	if not $BtnDelete.disabled:
		$IconDelete.frame = 0
		

func _on_BtnToAlbum_mouse_entered():
	if not $BtnToAlbum.disabled:
		$IconMove.frame = 1


func _on_BtnToAlbum_mouse_exited():
	if not $BtnToAlbum.disabled:
		$IconMove.frame = 0
