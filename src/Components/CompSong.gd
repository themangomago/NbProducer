extends Control

var assignedNode = null

func setup(node):
	if node.data.onAlbum:
		$BtnToAlbum.hide()

	$LSong.set_text(node.data.title)
	
	if node.data.ready:
		$LRating.set_text("R:" + str(node.data.quality))
		$LLength.set_text("L:" + str(node.data.duration))
	else:
		$LRating.set_text("R: ?")
		$LLength.set_text("L: ?")
		$BtnToAlbum.disabled = true
	assignedNode = node
	



func _on_BtnToAlbum_button_up():
	assignedNode.data.onAlbum = true
	get_parent().get_parent().updateGui()


func _on_BtnDelete_button_up():
	get_parent().get_parent().removeSong(assignedNode)
