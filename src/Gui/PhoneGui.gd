extends Control


var possibleTotalCredit = 20000
var totalOutstanding = 0
var totalCredit = 0
var rate = 5


var schoolCharNode = null
var schoolTraining = -1

var labelAlbum = -1

var advertise = -1

# {"upfront": 1000, "percentage": 20}
var labelOffer = [{"offerMade": false, "upfront": 1000, "percentage": 20}, \
	{"offerMade": false, "upfront": 1000, "percentage": 20}, \
	{"offerMade": false, "upfront": 1000, "percentage": 20}]


func _ready():
	$PJob/ObAdvertise.add_item("General: Musician")
	$PJob/ObAdvertise.add_item("Specific: Keyboard")
	$PJob/ObAdvertise.add_item("Specific: Guitar")
	$PJob/ObAdvertise.add_item("Specific: Bass")
	$PJob/ObAdvertise.add_item("Specific: Drum")
	$PJob/ObAdvertise.add_item("Specific: Texter")
	$PJob/ObAdvertise.add_item("Specific: Mixer")
	
	$PSchool/ObSubject.add_item("Specific: Singing")
	$PSchool/ObSubject.add_item("Specific: Keyboard")
	$PSchool/ObSubject.add_item("Specific: Guitar")
	$PSchool/ObSubject.add_item("Specific: Bass")
	$PSchool/ObSubject.add_item("Specific: Drum")


func updateGui():
	clear()

func newWeek():
	if advertise >= 0:
		var newNodesCount = randi()%4 
		if newNodesCount > 0:
			for i in range(newNodesCount):
				#TODO player create
				var node = Global.GI.ArtistFactory.newArtist(advertise)
				Global.GI.Applications.add_child(node)
		
	if schoolTraining >= 0:
		if schoolCharNode != null:
			musicSchool()

func musicSchool():
	var boost = max(0, schoolCharNode.character.talent - 5) * 4
	var skill = 0

	match schoolTraining:
		0:
			skill = schoolCharNode.character.skills.singer
		1:
			skill = schoolCharNode.character.skills.keyboard
		2:
			skill = schoolCharNode.character.skills.guitar
		3:
			skill = schoolCharNode.character.skills.bass
		4:
			skill = schoolCharNode.character.skills.drummer

	var chance
	if skill < 5:
		chance = 50
	elif skill < 7:
		chance = 25
	else:
		chance = 10
	
	if skill == 10:
		chance = 0
		boost = 0
	
	if Global.prngByChance(chance + boost):
		# Succesful
		if schoolCharNode.character.gender == "m":
			Global.GI.notifySilent("Artist " + schoolCharNode.character.name + " improved his skills", "Music School")
		else:
			Global.GI.notifySilent("Artist " + schoolCharNode.character.name + " improved her skills", "Music School")

		match schoolTraining:
			0:
				schoolCharNode.character.skills.singer = min(skill + 1, 10)
			1:
				schoolCharNode.character.skills.keyboard = min(skill + 1, 10)
			2:
				schoolCharNode.character.skills.guitar = min(skill + 1, 10)
			3:
				schoolCharNode.character.skills.bass = min(skill + 1, 10)
			4:
				schoolCharNode.character.skills.drummer = min(skill + 1, 10)

	else:
		# Not Successful
		if schoolCharNode.character.gender == "m":
			Global.GI.notifySilent("Artist " + schoolCharNode.character.name + " could not improve his skills", "Music School")
		else:
			Global.GI.notifySilent("Artist " + schoolCharNode.character.name + " could not improve her skills", "Music School")




func updatePossibleCredit():
	var base = 20000
	var loan = 0
	for album in Global.GI.getAlbums().get_children():
		if album.is_in_group("album"):
			if album.data.quality > 7:
				loan += 20000
				rate = 4
			elif album.data.quality > 5:
				loan += 10000
				rate = 5
			elif album.data.quality > 2:
				loan += 3000
				rate = 6
	possibleTotalCredit = loan + base
	


func prepareBank():
	var balanceNode = Global.GI.Balance
	totalOutstanding = 0
	totalCredit = 0
	
	updatePossibleCredit()
	
	$PBank/LCash.set_text("Balance: "+str(balanceNode.cash))
	
	$PBank/THistory.text = "History\n"
	for credit in balanceNode.credits:
		var total = float(credit.amount * (1 + float(credit.rate) / 100))
		var payRate = total / 24
		var remaining = max(0, total - (Global.GI.Week.week - credit.week) * payRate )
		totalOutstanding += remaining
		totalCredit += total
		$PBank/THistory.text += "Week: " + str(credit.week) + \
			" Loan: $" + str(credit.amount) + \
			" at " + str(credit.rate) + "% " + \
			"(Total: $" + str(total) + ")" + \
			" Outstanding: $" + str(remaining) + "\n"
	$PBank/THistory.text += "========================================================\nTotal Outstanding Loan: $" + str(totalOutstanding) 

	$PBank/TAmount.set_text(str(max(0, possibleTotalCredit - totalCredit)))

func prepareJob():
	if advertise >= 0:
		$PJob/BtnAdvertise.disabled = true
		$PJob/BtnAdvertise.text = "In Progress..."
	else:
		$PJob/BtnAdvertise.disabled = false
		$PJob/BtnAdvertise.text = "Advertise"

func prepareSchool():
	if schoolTraining >= 0:
		$PSchool/BtnSend.disabled = true
		$PSchool/BtnSend.text = "In Progress..."
	else:
		$PSchool/BtnSend.disabled = false
		$PSchool/BtnSend.text = "Send To School"
	
	$PSchool/ObPerson.clear()
	var player = Global.GI.getPlayer()
	$PSchool/ObPerson.add_item(player.character.name)
	for artist in Global.GI.getCompany().get_children():
		$PSchool/ObPerson.add_item(artist.character.name)

func prepareLabel():
	$PLabel/BtnLabel1.disabled = false
	$PLabel/BtnLabel2.disabled = false
	$PLabel/BtnLabel3.disabled = false
	$PLabel/BtnLabel1.text = "Get A Quote"
	$PLabel/BtnLabel2.text = "Get A Quote"
	$PLabel/BtnLabel3.text = "Get A Quote"
	$PLabel/TeLog.text = "Log:\n"
	
	labelAlbum = -1 
	$PLabel/ObAlbum.disabled = false
	
	for album in Global.GI.getAlbums().get_children():
		if album.is_in_group("album"):
			$PLabel/ObAlbum.add_item(album.data.title)

func updateLabel():
	pass

func clear():
	$PBank.hide()
	$PJob.hide()
	$PSchool.hide()
	$PLabel.hide()

func _on_BtnBank_button_up():
	clear()
	prepareBank()
	$PBank.show()

func _on_BtnJob_button_up():
	clear()
	prepareJob()
	$PJob.show()
	
func _on_BtnSchool_button_up():
	clear()
	prepareSchool()
	$PSchool.show()

func _on_BtnLabel_button_up():
	clear()
	prepareLabel()
	$PLabel.show()

func _on_BtnBorrow_button_up():
	if float($PBank/TAmount.text) <= (possibleTotalCredit - totalCredit):
		Global.GI.Balance.credits.append({"amount": float($PBank/TAmount.text), "rate": rate, "week": Global.GI.Week.week})
		Global.GI.Balance.cash += float($PBank/TAmount.text)
		prepareBank()


func _on_BtnAdvertise_button_up():
	if $PJob/ObAdvertise.selected != -1:
		advertise = $PJob/ObAdvertise.selected
		Global.GI.Balance.addPositionExpenses("Advertisement", 100)
		prepareJob()
	else:
		print("please select")


func _on_BtnSend_button_up():
	if $PSchool/ObPerson.selected == 0:
		if Global.GI.actionPoints >= Data.AP_COST_SELF_TRAINING:
			Global.GI.actionPoints -= Data.AP_COST_SELF_TRAINING

			schoolTraining = $PSchool/ObSubject.selected
			schoolCharNode = Global.GI.getPlayer()
			Global.GI.Balance.addPositionExpenses("Music School", 500)
			Global.GI.notify("You are going to the Music School", "Music School")
		else:
			Global.GI.notify("Not enough action points!", "Music School")
	else:
		if Global.GI.actionPoints >= Data.AP_COST_TRAINING:
			Global.GI.actionPoints -= Data.AP_COST_TRAINING
			schoolTraining = $PSchool/ObSubject.selected
			schoolCharNode = Global.GI.getCompany().get_child($PSchool/ObPerson.selected - 1)
			if schoolCharNode == null:
				print("Something went wrong: schoolCharNode == null")
			Global.GI.Balance.addPositionExpenses("Music School", 500)
			Global.GI.notify("Artist send to Music School", "Music School")
		else:
			Global.GI.notify("Not enough action points!", "Music School")
	prepareSchool()



func labelCondition(label):
	#TODO label condition
	return true

func btnLabelHandling(label):
	
	# Accept Offer
	if (label == 0 and labelOffer[0].offerMade == true) or \
		(label == 1 and labelOffer[1].offerMade == true) or \
		(label == 2 and labelOffer[2].offerMade == true):
		
		if Global.GI.actionPoints >= Data.AP_COST_BANK:
			Global.GI.actionPoints -= Data.AP_COST_BANK
			$PLabel/BtnLabel1.disabled = true
			$PLabel/BtnLabel2.disabled = true
			$PLabel/BtnLabel3.disabled = true
			$PLabel/TeLog.text += "Accepted offer from label " + str(label) + "\n"
			var albumNode = Global.GI.getAlbums().get_child($PLabel/ObAlbum.selected)
			albumNode.contract.label = label
			albumNode.contract.upfront = labelOffer[label].upfront
			albumNode.contract.percentage = labelOffer[label].percentage
			Global.GI.Balance.addPositionRevenue("Upfront Payment Label", labelOffer[label].upfront)
			Global.GI.notify("Signed contract with Label!")
		else:
			Global.GI.notify("Not enough action points!")
		
	# Offer
	else:
		$PLabel/ObAlbum.disabled = true
		labelAlbum = $PLabel/ObAlbum.selected
		
		# Check label conditions
		if labelCondition(label):
			# Create offer
			$PLabel/TeLog.text += "Offer from label " + str(label) + "\n"
			
			# Sign
			if label == 0:
				$PLabel/BtnLabel1.text = "Accept Offer"
				labelOffer[0].offerMade = true
			elif label == 1:
				$PLabel/BtnLabel2.text = "Accept Offer"
				labelOffer[1].offerMade = true
			elif label == 2:
				$PLabel/BtnLabel3.text = "Accept Offer"
				labelOffer[2].offerMade = true
			
		else:
			$PLabel/TeLog.text += "No offer from label " + str(label) + "\n"
			
			if label == 0:
				$PLabel/BtnLabel1.text = "No Offer"
				$PLabel/BtnLabel1.disabled = true
			elif label == 1:
				$PLabel/BtnLabel2.text = "No Offer"
				$PLabel/BtnLabel2.disabled = true
			elif label == 2:
				$PLabel/BtnLabel3.text = "No Offer"
				$PLabel/BtnLabel3.disabled = true


func _on_BtnLabel1_button_up():
	btnLabelHandling(0)


func _on_BtnLabel2_button_up():
	btnLabelHandling(1)


func _on_BtnLabel3_button_up():
	btnLabelHandling(2)
