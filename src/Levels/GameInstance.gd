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
onready var LogGui = $UI/LogGui
onready var Albums = $Albums
onready var Plan = $UI/PlanGui
onready var TalentPool = $TalentPool
onready var Newspaper = $UI/NewspaperGui
onready var Player = $Player

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

	SetupDebug()

func newGame():
	#Populate Talentpool
	$UI/Week.newGame()
	$UI/NewUserGui.updateGui()
	$UI/NewUserGui.show()

func continueGame():
	loadGame()

func loadGame():
	var data = Global.savegame
#Objects
	#TalentPool
	for talent in data.TalentPool:
		$TalentPool.add_child(ArtistFactory.restoreArtist(talent.character, talent.contract))
	#Club
	for talent in data.Club:
		$Club.add_child(ArtistFactory.restoreArtist(talent.character, talent.contract))
	#Player
		$Player.character = data.Player.character
		$Player.contract = data.Player.contract
	#Songs
	for song in data.Songs:
		$Songs.add_child($UI/ComposeGui.restoreSong(song.data))
	#Applications
	for talent in data.Applications:
		$Applications.add_child(ArtistFactory.restoreArtist(talent.character, talent.contract))
	#Company
	for talent in data.Company:
		$Company.add_child(ArtistFactory.restoreArtist(talent.character, talent.contract))
	#Album
	for album in data.Albums:
		$Albums.add_child($UI/ComposeGui.restoreAlbum(album.data, album.contract, album.songs))
#Data on Nodes
	Week.week = data.Week
	$UI/BalanceGui.cash = data.Cash
	$UI/BalanceGui.credits = data.Credits
	$UI/BalanceGui.expenses = data.Expenses
	$UI/BalanceGui.revenues = data.Revenues
	$UI/LogGui.setMemo(data.Memo)
	
	Week.clubWeek() #Put some artists back

	
func saveGame():
	var dictSave
	var dictTalentPool = []
	var dictClubPool = []
	var dictPlayer
	var dictSongs = []
	var dictApplications = []
	var dictCompany = []
	var dictAlbum = []

#Objects
	#TalentPool
	for talent in TalentPool.get_children():
		dictTalentPool.append({"character": talent.character, "contract": talent.contract})
	#Club
	for talent in $Club.get_children():
		dictClubPool.append({"character": talent.character, "contract": talent.contract})
	#Player
	dictPlayer = {"character": $Player.character, "contract": $Player.contract}
	#Songs
	for song in $Songs.get_children():
		dictSongs.append({"data": song.data})
	#Applications
	for talent in $Applications.get_children():
		dictApplications.append({"character": talent.character, "contract": talent.contract})
	#Company
	for talent in $Company.get_children():
		dictCompany.append({"character": talent.character, "contract": talent.contract})
	#Album
	for album in $Albums.get_children():
		var songs = []
		for song in album.get_children():
			songs.append({"data": song.data})
		dictAlbum.append({"data": album.data, "contract": album.contract, "songs": songs})

#Data on Nodes
	dictSave = {
		"Week": Week.week,
		"Cash": $UI/BalanceGui.cash,
		"Credits": $UI/BalanceGui.credits,
		"Expenses": $UI/BalanceGui.expenses,
		"Revenues": $UI/BalanceGui.revenues,
		"Memo": $UI/LogGui.getMemo(),
		"TalentPool": dictTalentPool,
		"Club": dictClubPool,
		"Player": dictPlayer,
		"Songs": dictSongs,
		"Applications": dictApplications,
		"Company": dictCompany,
		"Albums": dictAlbum
		}

	Global.saveGame(dictSave)




func SetupDebug():
	var cat1 = Debug.addCategory("ArtistFactory")
	Debug.addOption(cat1, "Add 1 Artist to Company", funcref(self, "debugAddArtist"), 1)
	Debug.addOption(cat1, "Add 5 Artists to Company", funcref(self, "debugAddArtist"), 5)

func debugAddArtist(count):
	for i in range(count):
		var node = ArtistFactory.newArtist(0)
		node.contract.salary = 100
		Company.add_child(node)
		print("> created: " + node.character.name)

func _physics_process(delta):
	$UI.setInfo($UI/Week.week, Balance.cash, actionPoints)


func nextWeek():
	#Remove old stuff
	# for i in range(0, $Applications.get_child_count()): #TODO: no need to remove old applications?
	# 	$Applications.get_child(i).queue_free()
	actionPoints = 20
	$UI.newWeek()
	




func checkAp(req, src):
	if actionPoints >= req:
		return true
	Notification.warn("Not enough action points!")
	return false

func decAp(req):
	actionPoints -= req

## DUMMY FUNCTIONS

func scoutClub(id):
	if not $UI/Week.playerHasVisitedClubThisWeek:
		if actionPoints >= Data.AP_COST_VISIT_CONCERT:
			$UI/Week.playerHasVisitedClubThisWeek = true
			$UI.showClub(id)
			selectedScoutedArtist = id
			actionPoints -= Data.AP_COST_VISIT_CONCERT
	else:
		Notification.warn("You have already visited a club this week.")

func negotiateTalent(talent):
	if actionPoints >= Data.AP_COST_VISIT_CONCERT:
		$UI.showNegotiation(talent)
		actionPoints -= Data.AP_COST_VISIT_CONCERT

func hireTalent(talent):
	$Club.remove_child(talent)
	$Company.add_child(talent)
	Notification.notify("Talent hired: " + talent.character.name, "HR")

#func notify(string, from = ""):
#	print("deprecated: " + str(string) + " from: " + from)
#	Notification.notify(string, from)
#	$UI/LogGui.addDiary(string, from)
#
#func notifySilent(string, from):
#	print("deprecated: " + str(string) + " from: " + from)
#	Notification.notifySilent(string, from)
#	$UI/LogGui.addDiary(string, from)


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
		Types.Target.Plan:
			$UI.showPlan()
		Types.Target.TV:
			saveGame()
			Global.gm.stateTransition(Types.GameStates.Menu)
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
