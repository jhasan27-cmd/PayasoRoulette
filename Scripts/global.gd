extends Node2D
@onready var click_detector: Button = $Cards/P1Cards/BaseCard/ClickDetector

var cardTemplate = "res://Cards/"

var Dick = ["Dizzy","Dizzy","Dizzy","Dizzy","Dizzy","Dizzy","Dizzy","Dizzy","Dizzy"]
var Deck = [
	"Desperate","Desperate","Distract","Distract","Distract","Dizzy","Dizzy","DulceDuel","DulceDuel", "Evoker","Evoker","GoneGlobo",
	"GoneGlobo","Horoscope","Horoscope","Jester","Jester","Kirby","Kirby","Leftovers","Leftovers","Lobotomy","LostNose",
	"LostNose","Mindgames","Mindgames","Mindread","Mindread","PayasoPacifier","PayasoPacifier","PayasoPainTrain","PayasoPainTrain",
	"Quieronino","Quieronino","Schlumblo","Schlumblo","Schlumblo","Sugarcaer","Sugarcaer","Yoink","Yoink"	
	]
var unusedCards = ["JoesphJoestar"]
var Discard = []

var P1Cards = []
var P1CardsNames = []
var P2Cards = []
var P2CardsNames = []

var selectedCard
var P1CardNum = 0
var P2CardNum = 0

var ThotsLeft = 0 #El Payaso BAGGGGSSSS EM
var Turn = 1


signal ThoughtChanged
signal drawCard
signal cardUsed

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	ThotChange(1)
	for i in 3:
		emit_signal("drawCard", 1)
		await get_tree().create_timer(.5).timeout
	Turn = 2
	for i in 3:
		emit_signal("drawCard", 2)
		await get_tree().create_timer(.5).timeout
	Turn = 1

	#emit_signal("drawCard", 1)
	pass
	#ThotChange(10)


func ThotChange(Change):
	ThotsLeft += Change
	emit_signal("ThoughtChanged")

func drawCardFunc():
	emit_signal("drawCard")
