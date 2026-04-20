extends Node2D
var Pos = []
var xPos1 = [[30.0],[-30.0, 90.0], [-90.0, 30, 150], [-150.0,-30.0,90.0, 210.0], [-210.0,-90.0, 30.0, 150.0, 270.0],[-330.0,-210.0,-90.0, 30.0, 150.0, 270.0]]
var xPos2 = [[30.0],[-30.0, 90.0], [-90.0, 30, 150], [-150.0,-30.0,90.0, 210.0], [-210.0,-90.0, 30.0, 150.0, 270.0],[-210.0,-90.0, 30.0, 150.0, 270.0, 390.0]]
var rng = RandomNumberGenerator.new()
var cardFilePaths = [
	["Desperate", ["res://Cards/Desperate/1/card.png","res://Cards/Desperate/2/card.png"],"T"],["Distract",["res://Cards/Distract/1/card.png", "res://Cards/Distract/2/card.png","res://Cards/Distract/3/card.png"],"T"],["Dizzy",["res://Cards/Dizzy/1/card.png","res://Cards/Dizzy/2/card.png"],"T"],
	["DulceDuel",["res://Cards/DulceDuel/1/card.png","res://Cards/DulceDuel/2/card.png"],"T"],["Evoker", ["res://Cards/DulceDuel/1/card.png","res://Cards/DulceDuel/2/card.png"],"T"], ["GoneGlobo",["res://Cards/GoneGlobo/1/card.png","res://Cards/GoneGlobo/2/card.png"],"T"],
	["Horoscope",["res://Cards/Horoscope/1/card.png","res://Cards/Horoscope/2/card.png"],"T"], ["Jester", ["res://Cards/Jester/1/card.png","res://Cards/Jester/2/card.png"],"T"], ["Kirby",["res://Cards/Kirby/1/card.png","res://Cards/Kirby/2/card.png"],"C"], ["Leftovers",["res://Cards/Leftovers/1/card.png","res://Cards/Leftovers/2/card.png"],"C"],
	["Lobotomy",["res://Cards/Lobotomy/1/card.png"],"L"], ["LostNose",["res://Cards/LostNose/1/card.png","res://Cards/LostNose/2/card.png"],"R"], ["Mindgames",["res://Cards/Mindgames/1/card.png","res://Cards/Mindgames/2/card.png"],"T"], ["Mindread",["res://Cards/Mindread/1/card.png","res://Cards/Mindread/2/card.png"],"C"],
	["PayasoPacifier",["res://Cards/PayasoPacifier/1/card.png","res://Cards/PayasoPacifier/2/card.png"],"T"], ["PayasoPainTrain",["res://Cards/PayasoPainTrain/1/card.png","res://Cards/PayasoPainTrain/2/card.png"],"T"], ["Quieronino",["res://Cards/Quieronino/1/card.png","res://Cards/Quieronino/2/card.png"],"C"],
	["Schlumblo",["res://Cards/Schlumblo/1/card.png","res://Cards/Schlumblo/2/card.png","res://Cards/Schlumblo/3/card.png"],"C"], ["Sugarcaer",["res://Cards/Sugarcaer/1/card.png","res://Cards/Sugarcaer/2/card.png"],"T"], ["Yoink",["res://Cards/Yoink/1/card.png","res://Cards/Yoink/2/card.png"],"T"]
]



@onready var template: Sprite2D = $"../../ReplicatedStorage/BaseCard"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.drawCard.connect(addCard)
	Global.cardUsed.connect(Test)
	
	for card in range(get_child_count()):
		if name == "P1Cards":
			get_children()[card].position.y = 330
			Global.P1Cards.insert(card, get_children()[card])
		elif name == "P2Cards":
			get_children()[card].position.y = -330
			Global.P2Cards.insert(card, get_children()[card])
		Pos.insert(card, get_children()[card].position)
	await get_tree().create_timer(0.1).timeout
	cardPosSort()

func Test(player, card):
	var filteredCards
	if player == "1" and name == "P1Cards":
		print(card)
	elif player == "2" and name == "P2Cards":
#		filteredCards = Global.P2CardsNames.filter(func(item): return item == card.get_children()[0].text)
		filteredCards = Global.P2CardsNames.find(card.get_children()[0].text)
		Pos.remove_at(Pos.find(card.position))
		Global.Discard.push_back(Global.P2CardsNames.pop_at(filteredCards))
		Global.P2Cards.pop_at(filteredCards).queue_free()
		Global.P2CardNum -= 1
		print(Global.Discard)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cardPosSort()
	if  self.get_class() == "Node2D":
		dancingCards()
	else:
		position = position + Vector2(rng.randf_range(-1,1),rng.randf_range(-1,1))
		
	for card in range(get_child_count()):
		#get_children()[card].ClickDetector.mouse_entered.connect(mouse_entered.bind(get_children()[card].name))
		pass

func addCard(player):
	var newCardNumber = rng.randi_range(0,Global.Deck.size()-1)
	var newCardName = Global.Deck[newCardNumber]
	var tempCardPaths = cardFilePaths
	var newPath
	var newPathScope
	var newPathTemplate

	for path in tempCardPaths:
		for item in path:
			if str(item) == newCardName:
				newPath = path
				newPathScope = newPath[1].size()-1
				newPathTemplate = newPath[1][rng.randi_range(0,newPathScope)]
				break
	
	if newPath != null:
		if player == 1 and name == "P1Cards":
			pass
			#Global.Discard.push_front(Global.Deck.pop_at(newCardNumber))
		elif player == 2 and name == "P2Cards":
			pass
			#Global.Discard.push_front(Global.Deck.pop_at(newCardNumber))
	if player == 1 and name == "P1Cards":
		var cardPath = template.get_path()
		var drawnCard = get_node(cardPath).duplicate(DUPLICATE_SIGNALS | DUPLICATE_SCRIPTS)
		var cardImage = Image.new()
		cardImage.load(newPathTemplate)

		
		var cardTexture = ImageTexture.new()
		cardTexture.create_from_image(cardImage)
		cardTexture.set_image(cardImage)
		drawnCard.texture = cardTexture
		drawnCard.position.y = 330
		Pos.push_back(drawnCard.position)
		
		Global.P1CardNum += 1
		Global.P1Cards.push_back(drawnCard)
		drawnCard.visible = true
		call_deferred("add_child", drawnCard)
		drawnCard.get_children()[0].text = newCardName
		Global.P1CardsNames.push_front(drawnCard.get_children()[0].text)
		drawnCard.get_children()[4].text = str(player)
		
	elif player == 2 and name == "P2Cards":
		var cardPath = template.get_path()
		var drawnCard = get_node(cardPath).duplicate(DUPLICATE_SIGNALS | DUPLICATE_SCRIPTS)
		var cardImage = Image.new()
		cardImage.load(newPathTemplate)
		
		var cardTexture = ImageTexture.new()
		cardTexture.create_from_image(cardImage)
		cardTexture.set_image(cardImage)
		drawnCard.texture = cardTexture
		#print(cardTexture)
		#print(drawnCard.texture)
		drawnCard.position.y = 0
		Pos.push_back(drawnCard.position)
		
		Global.P2CardNum += 1
		Global.P2Cards.push_back(drawnCard)
		drawnCard.visible = true
		call_deferred("add_child", drawnCard)
		drawnCard.get_children()[0].text = newCardName
		Global.P2CardsNames.push_front(drawnCard.get_children()[0].text)
		drawnCard.get_children()[4].text = str(player)

func dancingCards():
	var resetNum = rng.randi_range(1, 3) 
	for card in range(get_child_count()):
		get_children()[card].position += Vector2(rng.randf_range(-1,1),rng.randf_range(-1,1))
	if resetNum == 3:
		for card in range(get_child_count()):
			get_children()[card].position.x = Pos[card].x
			if get_children()[card] == Global.selectedCard:
				if Global.selectedCard.get_children()[4].text == str(Global.Turn):
					get_children()[card].position.y = 300
			else:
				if name == "P1Cards":
					if Global.Turn == 1:
						get_children()[card].position.y = 330
					else:
						get_children()[card].position.y = 0
				if name == "P2Cards":
					if Global.Turn == 2:
						get_children()[card].position.y = 330
					else:
						get_children()[card].position.y = 0
			if get_children()[card] == Global.selectedCard:
				if Global.selectedCard.get_children()[4].text == str(Global.Turn):
					get_children()[card].position.y -= 30

func cardPosSort():
	var childCount = get_child_count()
	if name == "P1Cards":
		for card in range(get_child_count()):
			if Global.Turn == 1:
				Pos[card].x = xPos1[childCount - 1][card - 1] 
				get_children()[card].position.x = xPos1[childCount - 1][card - 1]
				
			else:
				Pos[card].x = xPos2[childCount - 1][card - 1] 
				get_children()[card].position.x = xPos2[childCount - 1][card - 1]
				
	else:		
		for card in range(get_child_count()):
			if Global.Turn == 1:
				Pos[card].x = xPos2[childCount - 1][card - 1] 
				get_children()[card].position.x = xPos2[childCount - 1][card - 1]
			else:
				Pos[card].x = xPos1[childCount - 1][card - 1] 
				get_children()[card].position.x = xPos1[childCount - 1][card - 1]


func _on_child_order_changed() -> void:
	cardPosSort()



func _on_file_dialog_file_selected(path: String) -> void:
	print(path)
