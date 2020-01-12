extends Control


onready var playerNode = preload("res://src/Persons/Player.tscn")


var player = null
var actionPoints = 20
var lockPlayer = false




#Temp
var selectedScoutedArtist = 0


var ArtistFactory = load("res://src/Factories/ArtistFactory.gd").new()


onready var Week = $UI/Week
onready var Company = $Company
onready var Notification = $UI/Notification
onready var Balance = $UI/BalanceGui
onready var Applications = $Applications

func _ready():
	Global.GI = self
	
	# Spawn Player
	player = playerNode.instance()
	player.character.name = "Player"
	add_child(player)


	$UI/Week.connectArtistFactory(ArtistFactory)
	$UI/Week.connectTalentPool($TalentPool)
	$UI/Week.connectClub($Club)
	$UI/Week.connectCompany(Company)

	Company.connectClub($Club)
	
	$UI.connectClub($Club)
	
	$Level/Player.connectUI($UI)

	#TODO
	newGame()

func _physics_process(delta):
	$UI.setInfo($UI/Week.week, Balance.cash, actionPoints)


func nextWeek():
	#Remove old stuff
	for i in range(0, $Applications.get_child_count()):
		$Applications.get_child(i).queue_free()
	actionPoints = 20
	$UI.newWeek()
	

func newGame():
	$UI/Week.newGame()



## DUMMY FUNCTIONS

func scoutClub(id):
	if not $UI/Week.playerHasVisitedClubThisWeek:
		if actionPoints >= Data.AP_COST_VISIT_CONCERT:
			$UI/Week.playerHasVisitedClubThisWeek = true
			$UI.showClub(id)
			selectedScoutedArtist = id
			actionPoints -= Data.AP_COST_VISIT_CONCERT

func negotiateTalent(talent):
	if actionPoints >= Data.AP_COST_VISIT_CONCERT:
		$UI.showNegotiation(talent)
		actionPoints -= Data.AP_COST_VISIT_CONCERT

func hireTalent(talent):
	$Club.remove_child(talent)
	$Company.add_child(talent)
	Notification.notify("Talent hired: " + talent.character.name, "HR")

func notify(string, from = ""):
	Notification.notify(string, from)
	$UI/LogGui.addDiary(string, from)

func notifySilent(string, from):
	Notification.notifySilent(string, from)
	$UI/LogGui.addDiary(string, from)
	

func performAction(type):
	match type:
		Types.Target.NextWeek:
			nextWeek()
		Types.Target.Newspaper:
			$UI.showNewspaper()
		Types.Target.GoUp:
			$Level/Player.position = $Level/Staircase/StairWayUpper.global_position
		Types.Target.GoDown:
			$Level/Player.position = $Level/Staircase/StairWayCellar.global_position
		Types.Target.Balance:
			$UI.showBalance()
		Types.Target.Compose:
			$UI.showCompose()
		Types.Target.Phone:
			$UI.showPhone()
		Types.Target.Log:
			$UI.showLog()
		_:
			print("Unhandled Action")


func getTalentPool():
	return $TalentPool

func getCompany():
	return $Company

func getPlayer():
	return $Player

func getSongs():
	return $Songs

func getAlbums():
	return $Albums



func _on_BtnNextWeek_button_up():
	nextWeek()

func _on_BtnHireArtist_button_up():
	Company.hireNewArtist(selectedScoutedArtist)
