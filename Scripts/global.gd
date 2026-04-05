extends Node2D

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
	#emit_signal("drawCard", 1)
	await get_tree().create_timer(2).timeout
	#emit_signal("drawCard", 1)
	pass
	#ThotChange(10)


func ThotChange(Change):
	ThotsLeft += Change
	emit_signal("ThoughtChanged")

func drawCardFunc():
	emit_signal("drawCard")
