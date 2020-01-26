extends CanvasLayer

var Club = null

var activeDisplay = null
var lastUpdateOnWeek = 0


func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		closeActive()

func connectClub(pool):
	Club = pool

func closeActive():
	if activeDisplay:
		$BtnClose.hide()
		$Bg.hide()
		activeDisplay.hide()
		activeDisplay = null

func setActive(node):
	$Bg.show()
	$BtnClose.show()
	node.show()
	activeDisplay = node

func showNewspaper():
	assert(Club != null)
	closeActive()
	if lastUpdateOnWeek < Global.GI.Week.week:
		$NewspaperGui.setArtists(Club.get_child(0).character, Club.get_child(1).character, Club.get_child(2).character)
		lastUpdateOnWeek = Global.GI.Week.week
	setActive($NewspaperGui)

func showClub(id):
	closeActive()
	$ClubGui.setArtist(Club.get_child(id))
	setActive($ClubGui)

func showNegotiation(talent):
	closeActive()
	$NegotiationGui.setArtist(talent)
	setActive($NegotiationGui)
	
func showBalance():
	closeActive()
	setActive($BalanceGui)

func showCompose():
	closeActive()
	$ComposeGui.updateGui()
	setActive($ComposeGui)

func showPhone():
	closeActive()
	$PhoneGui.updateGui()
	setActive($PhoneGui)

func showLog():
	closeActive()
	$LogGui.updateGui()
	setActive($LogGui)

func showPlan():
	closeActive()
	$PlanGui.updateGui()
	setActive($PlanGui)

func newWeek():
	closeActive()
	setActive($Week)
	$Week.newWeek()
	$ComposeGui.newWeek()
	$PhoneGui.newWeek()
	
func setInfo(week, cash, actionPoints):
	$BottomUi.setInfo(week, cash, actionPoints)

func _on_BtnClose_button_up():
	closeActive()
