extends Button

signal card_hovered
signal card_unhovered
signal card_clicked
var usedSignal = Global.cardUsed

@onready var template: Sprite2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", chickenGun)
	connect("mouse_exited", chickenRun)
	connect("button_down", chickenRun)
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if self.get_parent() == Global.selectedCard:
			usedSignal.emit(self.get_parent().get_children()[4].text, self.get_parent())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func chickenGun():
	if str(Global.Turn) == self.get_parent().get_children()[4].text:
		Global.selectedCard = self.get_parent()
	pass
	
func chickenRun():
	Global.selectedCard = null
	pass

func _on_mouse_entered() -> void:
	card_hovered.emit(self)
