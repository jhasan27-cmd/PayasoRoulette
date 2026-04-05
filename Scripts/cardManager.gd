extends Node2D
var Pos = []
var xPos1 = [[30.0],[-30.0, 90.0], [-90.0, 30, 150], [-150.0,-30.0,90.0, 210.0], [-210.0,-90.0, 30.0, 150.0, 270.0],[-330.0,-210.0,-90.0, 30.0, 150.0, 270.0]]
var xPos2 = [[30.0],[-30.0, 90.0], [-90.0, 30, 150], [-150.0,-30.0,90.0, 210.0], [-210.0,-90.0, 30.0, 150.0, 270.0],[-210.0,-90.0, 30.0, 150.0, 270.0, 390.0]]
var rng = RandomNumberGenerator.new()
@onready var template: AnimatedSprite2D = $"../../ReplicatedStorage/BaseCard"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	if player == 1 and name == "P1Cards":
		print("cardAdded for P1")
		var cardPath = template.get_path()
		var drawnCard = get_node(cardPath).duplicate(DUPLICATE_SIGNALS | DUPLICATE_SCRIPTS)
		drawnCard.position.y = 330
		Pos.push_back( drawnCard.position)
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
	Global.selectedCard = card.get_parent()
	#card.get_parent().queue_free()

func on_card_unhovered(card):
	Global.selectedCard = null
	
	
