extends Label


# Called when the node enters the scene tree for the first time.

#Global.


func _on_node_2d_thought_changed() -> void:
	self.text = str(Global.ThotsLeft)
	self.position = Vector2(-202.273, -250)
