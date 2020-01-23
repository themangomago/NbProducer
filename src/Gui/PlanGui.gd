extends Control


var albums = []
var assigned = []

var album = null
var assignedSinger = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$BStudio.add_item("B. Smith ($5000)") # 1.2
	$BStudio.add_item("L. Andersson ($4000)") #1.1
	$BStudio.add_item("N. Kyle ($2500)") #0.9

func clearArtists():
	$BAlbum.clear()
	$BSinger.clear()
	$BKeyboard.clear()
	$BGuitar.clear()
	$BBass.clear()
	$BDrummer.clear()
	$BMixer.clear()
	
func newWeek():
	if album:
		assignedSinger.contract.duration -= 1
		
		print(assignedSinger.contract.duration)
		if assignedSinger.contract.duration <= 0:
			print("expired")
			#TODO move back to talent pool
		
		album.data.produced = true
		
		album = null
		assignedSinger = null
		$Button.set_text("Record it!")
		$Button.disabled = false


func updateGui():
	var player = Global.GI.getPlayer()
	albums = []
	clearArtists()
	
	#Album Loop
	for album in Global.GI.Albums.get_children():
		if album.data.produced == false:
			albums.append(album) #Store Data
			$BAlbum.add_item(album.data.title)
	
	#Player Setup
	$BKeyboard.add_item("You (" + str(player.character.skills.keyboard) + ")")
	$BGuitar.add_item("You (" + str(player.character.skills.guitar) + ")")
	$BBass.add_item("You (" + str(player.character.skills.bass) + ")")
	$BDrummer.add_item("You (" + str(player.character.skills.drummer) + ")")
	$BMixer.add_item("You (" + str(player.character.skills.mixer) + ")")

	#Artist Loop
	for artist in Global.GI.Company.get_children():
		var aname = Data.shortName(artist.character.name)
		var skills = artist.character.skills
		var costs = ""
		
		if artist.contract.signed == false:
			costs = "$" + str(artist.contract.salary)
		else:
			$BSinger.add_item(aname + " ("+ str(skills.singer) +") ")
		
		$BKeyboard.add_item(aname + " ("+ str(skills.keyboard) +") " + costs)
		$BGuitar.add_item(aname + " ("+ str(skills.guitar) +") " + costs)
		$BBass.add_item(aname + " ("+ str(skills.bass) +") " + costs)
		$BDrummer.add_item(aname + " ("+ str(skills.drummer) +") " + costs)
		$BMixer.add_item(aname + " ("+ str(skills.mixer) +") " + costs)



func _on_item_selected(id):
	calcTotal()



func calcTotal():
	var total = 0
	assigned = []
	#Hire Talents
	for optBtn in self.get_children():
		if optBtn.is_in_group("button"):
			assigned.append(optBtn.selected - 1) #Store for later
			if optBtn.selected > 0: #Dont evaluate not set and player
				var artist = Global.GI.Company.get_child(optBtn.selected - 1)
				if artist.contract.signed == false:
					total += artist.contract.salary
	
	#Match Studio
	match $BStudio.selected:
		0:
			total += 5000
		1:
			total += 4000
		_:
			total += 2500
	print(total)

func validate():
	var dupl = false
	for i in range(assigned.size()):
		for j in range(assigned.size()):
			if assigned[i] == assigned[j] and i != j:
				return false
	return true

func _on_Button_button_up():
	if albums == null:
		print("No album found")
		return
	
	if validate():
		if assigned.find(-1) != -1:
			if Global.GI.checkAp(Data.AP_COST_PLAN_SELF, "Recording"):
				Global.GI.decAp(Data.AP_COST_PLAN_SELF)
			else:
				return
			
		album = albums[$BAlbum.selected]
		
		#Rating  ((text+mix) * 2 + singer*2 + overall + mixer) * studioMod 
		var Company = Global.GI.Company
		var singer = Company.get_child($BSinger.selected).character.skills.singer
		
		var player = Global.GI.getPlayer()
		

		var skeyboard = 0
		if assigned[0] == -1:
			skeyboard = player.character.skills.keyboard
		else:
			skeyboard = Company.get_child(assigned[0]).character.skills.keyboard
		
		var sguitar = 0
		if assigned[1] == -1:
			sguitar = player.character.skills.guitar
		else:
			sguitar = Company.get_child(assigned[1]).character.skills.guitar
			
		var sbass = 0
		if assigned[2] == -1:
			sbass = player.character.skills.bass
		else:
			sbass = Company.get_child(assigned[2]).character.skills.bass
		
		var sdrummer = 0
		if assigned[3] == -1:
			sdrummer = player.character.skills.drummer
		else:
			sdrummer = Company.get_child(assigned[3]).character.skills.drummer
	
		var smixer = 0
		if assigned[4] == -1:
			smixer = player.character.skills.mixer
		else:
			smixer = Company.get_child(assigned[4]).character.skills.mixer
		
		var overall = float(skeyboard + sguitar + sbass + sdrummer) / 4
		var mixer = float(smixer)
		
		var studioMod = 0.9
		if $BStudio.selected == 0:
			studioMod = 1.2
		elif $BStudio.selected == 1:
			studioMod = 1.1
		
		var rating = int((album.data.quality * 2 + \
			singer * 2 + \
			overall + \
			mixer)/6 * studioMod)
		
		album.data.quality = rating
		
		#TODO add costs
		#TODO duration of artist not set correct
		
		assignedSinger = Company.get_child($BSinger.selected)
		$Button.set_text("Recording...")
		$Button.disabled = true
		
	else:
		print("DUPLICATE FOUND")
