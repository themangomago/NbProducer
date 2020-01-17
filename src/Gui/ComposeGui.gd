extends Control


var artistNodes = []

var song = null
var totalLength = 0

onready var songScene = preload("res://src/Songs/Song.tscn") 
onready var vSongScene = preload("res://src/Components/CompSong.tscn")
onready var albumScene = preload("res://src/Albums/Album.tscn")

const BOUNDARY_TOP = 60 * 60
const BOUNDARY_BOTTOM = 15 * 60

func clear():
	artistNodes.clear()
	$OptWriter.clear()
	$OptMelody.clear()
	
	for child in $VBoxSongs.get_children():
		child.hide()
		child.queue_free()
	
	for child in $VBoxAlbum.get_children():
		child.hide()
		child.queue_free()

func updateGui():
	clear()
	artistNodes.append(Global.GI.getPlayer())

	var company = Global.GI.getCompany()
	
	# Populate DropDowns
	for artist in company.get_children():
		artistNodes.append(artist)
		
	
	var first = true
	var index = 0
	for artist in artistNodes:
		
		$OptWriter.add_item(artist.character.name + " Skill: " + str(artist.character.skills.texter), index)
		
		var maxMelody = max(artist.character.skills.keyboard, artist.character.skills.guitar)
		$OptMelody.add_item(artist.character.name + " Skill: " + str(maxMelody), index)
		
		index += 1

	if song:
		switchRecordButton(false)
	else:
		switchRecordButton(true)

	var vSongNode = null
	var songs = Global.GI.getSongs()
	totalLength = 0
	for song in songs.get_children():
		vSongNode = vSongScene.instance()
		#setup(node, title, rating, onAlbum)
		if vSongNode.setup(song):
			if song.data.onAlbum:
				$VBoxAlbum.add_child(vSongNode)
				totalLength += song.data.duration
			else:
				$VBoxSongs.add_child(vSongNode)
		else:
			vSongNode = null


	if totalLength >= BOUNDARY_BOTTOM and totalLength <= BOUNDARY_TOP:
		$Length.bbcode_text = "Total Length: " + str(int(totalLength/60)) + ":%0*d" % [2, totalLength - int(totalLength/60)*60] 
	else:
		$Length.bbcode_text = "Total Length: [color=#b33831]" + str(int(totalLength/60)) + ":%0*d" % [2, totalLength - int(totalLength/60)*60] + "[/color]"


func switchRecordButton(to):
	if not to:
		$BtnNewSong.disabled = true
		$BtnNewSong.text = "Creating.."
	else:
		$BtnNewSong.disabled = false
		$BtnNewSong.text = "Create New Song"

func newWeek():
	if song:
		if song.data.ready == false:
			song.data.ready = true
			song = null

func removeSong(target):
	target.queue_free()
	
	$Timer.start()

func _on_BtnNewSong_button_up():
	if not song:
		# AP Costs
		var apReq = 0
		if artistNodes[$OptWriter.selected].is_in_group("player"):
			apReq += Data.AP_COST_COMPOSE
		if artistNodes[$OptMelody.selected].is_in_group("player"):
			apReq += Data.AP_COST_COMPOSE

		if Global.GI.actionPoints < apReq:
			Global.GI.notify("Not enough action points! Go to bed!")
			return
		
		Global.GI.actionPoints -= apReq

		#	"ready": false,
		#	"title": 0,
		#	"duration": 150,
		#	"quality": 0
		song = songScene.instance()
		song.data.ready = false
		song.data.title = $TeSongTitle.text
		song.data.duration = int(rand_range(120, 240))
		var base = (float(artistNodes[$OptWriter.selected].character.skills.texter + max(artistNodes[$OptMelody.selected].character.skills.keyboard, artistNodes[$OptMelody.selected].character.skills.guitar)))/3
		var maxVal = 10
		if base < 4:
			maxVal = 8
		song.data.quality = int(rand_range(base, maxVal))
		Global.GI.getSongs().add_child(song)
		updateGui()



func _on_BtnRecord_button_up():
	print("TODO: check if production is already in progress")
	if totalLength >= BOUNDARY_BOTTOM and totalLength <= BOUNDARY_TOP:
		
		var count = 0
		var ratings = 0
		var modifier = 1
		var album = albumScene.instance()
		var songs = Global.GI.getSongs()

		for song in songs.get_children():
			if song.data.onAlbum:
				count += 1
				ratings += song.data.quality
				songs.remove_child(song)
				album.add_child(song)
		
		if totalLength > 40:
			modifier = 1.1
		if totalLength > 50:
			modifier = 1.2
		
		ratings = (ratings * modifier) / count
		 
		album.data.quality = ratings
		album.data.duration = totalLength
		album.data.title = $TeAlbumTitle.text
		Global.GI.getAlbums().add_child(album)
		updateGui()
		Global.GI.notify("Album is ready for recording!", "Compose")

	else:
		Global.GI.notify("Songs do not fit on LP!")


func _on_Timer_timeout():
	updateGui()
