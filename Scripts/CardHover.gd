extends Button

signal card_hovered
signal card_unhovered

@onready var template: Sprite2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", chickenGun)
	connect("mouse_exited", chickenRun)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func chickenGun():
	print("E")
	card_hovered.emit(self)
	pass
	
func chickenRun():
	print("F")
	card_unhovered.emit(self)
	pass

func _on_mouse_entered() -> void:
	card_hovered.emit(self)
