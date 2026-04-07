extends Node2D
@onready var click_detector: Button = $Cards/P1Cards/BaseCard/ClickDetector

var cardTemplate = "res://Cards/"

var Deck = [
	"Desperate","Desperate","Distract","Distract","Distract","Dizzy","Dizzy","DulceDuel","DulceDuel", "Evoker","Evoker","GoneGlobo",
	"GoneGlobo","Horoscope","Horoscope","Jester","Jester","JoesphJoestar","Kirby","Kirby","Leftovers","Leftovers","Lobotomy","LostNose",
	"LostNose","Mindgames","Mindgames","Mindread","Mindread","PayasoPacifier","PayasoPacifier","PayasoPainTrain","PayasoPainTrain",
	"Quieronino","Quieronino","Schlumblo","Schlumblo","Schlumblo","Sugarcaer","Sugarcaer","Yoink","Yoink"	
	]
var Discard = []

var P1Cards = []
var P2Cards = []

var selectedCard
var P1CardNum = 0
var P2CardNum = 0
var ThotsLeft = 0 #El Payaso BAGGGGSSSS EM


signal ThoughtChanged
signal drawCard

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	ThotChange(1)
	for i in 6:
		emit_signal("drawCard", 1)
		await get_tree().create_timer(2).timeout
	#emit_signal("drawCard", 1)
	pass
	#ThotChange(10)


func ThotChange(Change):
	ThotsLeft += Change
	emit_signal("ThoughtChanged")

func drawCardFunc():
	emit_signal("drawCard")
