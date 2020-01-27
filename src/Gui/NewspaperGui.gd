extends Control

var albums = []

func _ready():
	SetupDebug()
	
func SetupDebug():
	var cat2 = Debug.addCategory("Album")
	Debug.addOption(cat2, "Add 1", funcref(self, "debugAddAlbum"), 1)
	Debug.addOption(cat2, "Add 2", funcref(self, "debugAddAlbum"), 2)
	
	
func debugAddAlbum(count):
	var scene = load("res://src/Albums/Album.tscn")
	
	for i in range(count):
		var node = scene.instance()
		node.data.title = "Beyond the Morningstar"
		node.data.produced = true
		node.data.released = true
		node.data.quality = 9 +i 
		Global.GI.Albums.add_child(node)

func setArtists(club1, club2, club3):
	$Layout/Artist1.set_text(club1.name + ", "+club1.gender+str(club1.age))
	$Layout/Artist2.set_text(club2.name + ", "+club2.gender+str(club2.age))
	$Layout/Artist3.set_text(club3.name + ", "+club3.gender+str(club3.age))
	
	var week = Global.GI.Week.week
	$Layout/Week.set_text("Week " + str(week))



func clearCharts():
	albums = []
	$Layout/ChartHit.hide()
	$Layout/ChartHit.rect_position = Vector2(544, 157)
	$Layout/ChartHit2.hide()
	$Layout/ChartHit2.rect_position = Vector2(544, 157)
	
func addToChart(album, sales):
	if sales >= 55000:
		albums.append({"title": album.data.title, "sales": sales})
		#print(albums)
	
func updateCharts():
	if albums.size() >= 2:
		$Layout/ChartHit.show()
		$Layout/ChartHit2.show()

		if albums[0].sales < albums[1].sales:
			var temp = albums[1]
			albums[1] = albums[0]
			albums[0] = temp
		var position = getSize(albums[0].sales)
		print(position)
		$Layout/ChartHit.set_text(" "+str(position)+".  " + albums[0].title)
		$Layout/ChartHit.rect_position.y = 157 + 20 * (position - 1)
		var old = position
		position = getSize(albums[1].sales)
		print(position)
		if old == position:
			position += 1
		$Layout/ChartHit2.set_text(" "+str(position)+".  " + albums[1].title)
		$Layout/ChartHit2.rect_position.y = 157 + 20 * (position - 1)

	else:
		if albums.size() == 1:
			$Layout/ChartHit.show()
			var position = getSize(albums[0].sales)
			print(position)
			$Layout/ChartHit.set_text(" "+str(position)+".  " + albums[0].title)
			$Layout/ChartHit.rect_position.y = 157 + 20 * (position - 1)

func getSize(sales):
# 1: 100k 0 
# 2: 95 5
# 3: 90 
# 4: 85
# 5: 80 ->
# 6: 75
# 7: 70
# 8: 65
# 9: 60
# 10: 55
	var c = 10
	if sales > 95000:
		c = 1
	elif sales > 90000:
		c = 2
	elif sales > 85000:
		c = 3
	elif sales > 80000:
		c = 4
	elif sales > 75000:
		c = 5
	elif sales > 70000:
		c = 6
	elif sales > 65000:
		c = 7
	elif sales > 60000:
		c = 8
	elif sales > 55000:
		c = 9
	return c
		


func _on_BtnClub1_button_up():
	Global.GI.scoutClub(0)
	Global.click()


func _on_BtnClub2_button_up():
	Global.GI.scoutClub(1)
	Global.click()


func _on_BtnClub3_button_up():
	Global.GI.scoutClub(2)
	Global.click()
