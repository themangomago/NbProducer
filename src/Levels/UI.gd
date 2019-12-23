extends CanvasLayer

var Club = null

var activeDisplay = null

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		closeActive()

func connectClub(pool):
	Club = pool

func closeActive():
	if activeDisplay:
		activeDisplay.hide()
		activeDisplay = null

func setActive(node):
	node.show()
	activeDisplay = node

func showNewspaper():
	assert(Club != null)
	closeActive()
	$NewspaperGui.setArtists(Club.get_child(0).character.name, Club.get_child(1).character.name, Club.get_child(2).character.name)
	setActive($NewspaperGui)

func showClub(id):
	closeActive()
	$ClubGui.setArtist(Club.get_child(id))
	setActive($ClubGui)

func showNegotiation(talent):
	closeActive()
	$NegotiationGui.setArtist(talent)
	setActive($NegotiationGui)
	
