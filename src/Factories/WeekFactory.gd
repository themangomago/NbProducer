extends Node



var playerHasVisitedClubThisWeek = false
var week = 0


# Intern
var ArtistFactory = null
var TalentPool = null
var Club = null
var Company = null




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func connectArtistFactory(factory):
	ArtistFactory = factory

func connectTalentPool(pool):
	TalentPool = pool

func connectClub(club):
	Club = club

func connectCompany(this):
	Company = this


func clubWeek():
	#Move all Club Talents back to TalentPool
	for i in Club.get_child_count():
		var node = Club.get_child(0)
		Club.remove_child(node)
		TalentPool.add_child(node)

	for i in range(3):
		var id = randi() % TalentPool.get_child_count()
		var node = TalentPool.get_child(id)
		TalentPool.remove_child(node)
		Club.add_child(node)


func newWeek():
	clubWeek()
	playerHasVisitedClubThisWeek = false
	week += 1
	Company.newWeek()


func newGame():
	# Populate Talent Pool
	for i in range(10):
		TalentPool.add_child(ArtistFactory.newSinger())
	
	newWeek()