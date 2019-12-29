extends Control


onready var playerNode = preload("res://src/Persons/Player.tscn")


var player = null
var actionPoints = 20
var lockPlayer = false


const AP_COST_VISIT_CONCERT = 5
const AP_COST_NEGOTIATION = 3

#Temp
var selectedScoutedArtist = 0


var ArtistFactory = load("res://src/Factories/ArtistFactory.gd").new()

onready var Company = $Company

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
	$UI/Label.set_text("Week: "+ str($UI/Week.week) + " $" + str(Company.cash) + "  AP:" + str(actionPoints))

func nextWeek():

	$UI/Week.newWeek()
	

func newGame():
	$UI/Week.newGame()



## DUMMY FUNCTIONS

func scoutClub(id):
	if not $UI/Week.playerHasVisitedClubThisWeek:
		if actionPoints >= AP_COST_VISIT_CONCERT:
			$UI/Week.playerHasVisitedClubThisWeek = true
			$UI.showClub(id)
			selectedScoutedArtist = id
			actionPoints -= AP_COST_VISIT_CONCERT

func negotiateTalent(talent):
	if actionPoints >= AP_COST_VISIT_CONCERT:
		$UI.showNegotiation(talent)
		actionPoints -= AP_COST_VISIT_CONCERT

func hireTalent(talent):
	$Club.remove_child(talent)
	$Company.add_child(talent)

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



func _on_BtnNextWeek_button_up():
	nextWeek()

func _on_BtnHireArtist_button_up():
	Company.hireNewArtist(selectedScoutedArtist)
