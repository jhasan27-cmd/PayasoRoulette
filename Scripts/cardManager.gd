extends Node2D
var Pos = []
var xPos1 = [[30.0],[-30.0, 90.0], [-90.0, 30, 150], [-150.0,-30.0,90.0, 210.0], [-210.0,-90.0, 30.0, 150.0, 270.0],[-330.0,-210.0,-90.0, 30.0, 150.0, 270.0]]
var xPos2 = [[30.0],[-30.0, 90.0], [-90.0, 30, 150], [-150.0,-30.0,90.0, 210.0], [-210.0,-90.0, 30.0, 150.0, 270.0],[-210.0,-90.0, 30.0, 150.0, 270.0, 390.0]]
var rng = RandomNumberGenerator.new()
var cardFilePaths = [
	["Desperate", ["res://Cards/Desperate/1/card.png","res://Cards/Desperate/2/card.png"]],["Distract",["res://Cards/Distract/1/card.png", "res://Cards/Distract/2/card.png","res://Cards/Distract/3/card.png"]],["Dizzy",["res://Cards/Dizzy/1/card.png","res://Cards/Dizzy/3/card.png"]],
	["DulceDuel",["res://Cards/DulceDuel/1/card.png","res://Cards/DulceDuel/2/card.png"]],["Evoker", ["res://Cards/DulceDuel/1/card.png","res://Cards/DulceDuel/2/card.png"]], ["GoneGlobo",["res://Cards/GoneGlobo/1/card.png","res://Cards/GoneGlobo/2/card.png"]],
	["Horoscope",["res://Cards/Horoscope/1/card.png","res://Cards/Horoscope/2/card.png"]], ["Jester", ["res://Cards/Jester/1/card.png","res://Cards/Jester/2/card.png"]], ["Kirby",["res://Cards/Kirby/1/card.png","res://Cards/Kirby/2/card.png"]], ["Leftovers",["res://Cards/Leftovers/1/card.png","res://Cards/Leftovers/2/card.png"]],
	["Lobotomy",["res://Cards/Lobotomy/1/card.png"]], ["LostNose",["res://Cards/LostNose/1/card.png","res://Cards/LostNose/2/card.png"]], ["Mindgames",["res://Cards/Mindgames/1/card.png","res://Cards/Mindgames/2/card.png"]], ["Mindread",["res://Cards/Mindread/1/card.png","res://Cards/Mindread/2/card.png"]],
	["PayasoPacifier",["res://Cards/PayasoPacifier/1/card.png","res://Cards/PayasoPacifier/2/card.png"]], ["PayasoPainTrain",["res://Cards/PayasoPainTrain/1/card.png","res://Cards/PayasoPainTrain/2/card.png"]], ["Quieronino",["res://Cards/Quieronino/1/card.png","res://Cards/Quieronino/2/card.png"]],
	["Schlumblo",["res://Cards/Schlumblo/1/card.png","res://Cards/Schlumblo/2/card.png","res://Cards/Schlumblo/3/card.png"]], ["Sugarcaer",["res://Cards/Sugarcaer/1/card.png","res://Cards/Sugarcaer/2/card.png"]], ["Yoink",["res://Cards/Yoink/1/card.png","res://Cards/Yoink/2/card.png"]]
]

signal card_hovered
signal card_unhovered


@onready var template: Sprite2D = $"../../ReplicatedStorage/BaseCard"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	card_hovered.connect(on_card_hovered)
	card_unhovered.connect(on_card_unhovered)
	Global.drawCard.connect(addCard)
	
	for card in range(get_child_count()):
		if name == "P1Cards":
			get_children()[card].position.y = 330
			Global.P1Cards.insert(card, get_children()[card])
			var child = get_children()[card]
			var childPath = child.get_node("ClickDetector").get_path()
			
			get_node(childPath).card_hovered.connect(on_card_hovered)
			get_node(childPath).card_unhovered.connect(on_card_unhovered)
		else:
			get_children()[card].position.y = 0
			Global.P2Cards.insert(card, get_children()[card])
		Pos.insert(card, get_children()[card].position)
	await get_tree().create_timer(0.1).timeout
	cardPosSort()



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
	
	print(newCardName)
	for path in tempCardPaths:
		for item in path:
			if str(item) == newCardName:
				newPath = path
				newPathScope = newPath[1].size()-1
				newPathTemplate = newPath[1][rng.randi_range(0,newPathScope)]
				break
	if newPath != null:
		print(newPathTemplate)
		var usedCard = Global.Deck.pop_at(newCardNumber)
		Global.Discard.push_front(usedCard)
		print(Global.Discard)
	
	if player == 1 and name == "P1Cards":
		print("cardAdded for P1")
		var cardPath = template.get_path()
		var drawnCard = get_node(cardPath).duplicate(DUPLICATE_SIGNALS | DUPLICATE_SCRIPTS)
		var cardImage = Image.new()
		print(newPathTemplate)
		cardImage.load(newPathTemplate)
		#newPathTemplate+"Icon.png"
		#cardImage.load("res://Cards/Distract/1/card.png")
		var cardTexture = ImageTexture.new()
		cardTexture.create_from_image(cardImage)
		cardTexture.set_image(cardImage)
		drawnCard.texture = cardTexture
		print(cardTexture)
		print(drawnCard.texture)
		drawnCard.position.y = 330
		Pos.push_back(drawnCard.position)
		
		Global.P1CardNum += 1
		Global.P1Cards.push_back(drawnCard)
		drawnCard.visible = true
		call_deferred("add_child", drawnCard)
		
		
	elif player == 2 and name == "P2Cards":
		print("cardAdded for P2")
	else:
		print("no cards drawn")
	pass

func dancingCards():
	var resetNum = rng.randi_range(1, 3) 
	for card in range(get_child_count()):
		get_children()[card].position += Vector2(rng.randf_range(-1,1),rng.randf_range(-1,1))
	if resetNum == 3:
		for card in range(get_child_count()):
			get_children()[card].position = Pos[card]
			if get_children()[card] == Global.selectedCard:
				get_children()[card].position.y -= 30


func _on_child_order_changed() -> void:
	cardPosSort()


	
func cardPosSort():
	var childCount = get_child_count()
	if name == "P1Cards":
		for card in range(get_child_count()):
			Pos[card].x = xPos1[childCount - 1][card - 1] 
			get_children()[card].position.x = xPos1[childCount - 1][card - 1]
	else:
		for card in range(get_child_count()):
				Pos[card].x = xPos2[childCount - 1][card - 1] 
				get_children()[card].position.x = xPos2[childCount - 1][card - 1]


func on_card_hovered(card):
	print("G")
	Global.selectedCard = card.get_parent()
	#card.get_parent().queue_free()

func on_card_unhovered(card):
	print("H")
	Global.selectedCard = null
	
	


func _on_file_dialog_file_selected(path: String) -> void:
	print(path)
