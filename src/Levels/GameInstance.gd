extends Control


onready var playerNode = preload("res://src/Persons/Player.tscn")


var player = null
var actionPoints = 20



const AP_COST_VISIT_CONCERT = 4

#Temp
var selectedScoutedArtist = 0


var ArtistFactory = load("res://src/Factories/ArtistFactory.gd").new()
var Week = load("res://src/Factories/WeekFactory.gd").new()
onready var Company = $Company

func _ready():
	Global.GI = self
	
	# Spawn Player
	player = playerNode.instance()
	player.character.name = "Player"
	add_child(player)

	
	Week.connectArtistFactory(ArtistFactory)
	Week.connectTalentPool($TalentPool)
	Week.connectClub($Club)
	Week.connectCompany(Company)

	Company.connectClub($Club)
	
	$UI.connectClub($Club)
	
	$Level/Player.connectUI($UI)

	#TODO
	newGame()

func _physics_process(delta):
	pass
	#$CanvasLayer/Label.set_text("Week: "+ str(Week.week) + " $" + str(Company.cash) + "  AP:" + str(actionPoints))

func nextWeek():
	Week.newWeek()
	

func newGame():
	Week.newGame()



## DUMMY FUNCTIONS

func scoutClub(id):
	if not Week.playerHasVisitedClubThisWeek:
		if actionPoints >= AP_COST_VISIT_CONCERT:
			Week.playerHasVisitedClubThisWeek = true
			$UI.showClub(id)
			selectedScoutedArtist = id
			actionPoints -= AP_COST_VISIT_CONCERT


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
