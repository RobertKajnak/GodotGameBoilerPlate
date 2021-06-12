extends VBoxContainer


var letters setget set_letters, get_letters

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_letters(letters:String):
	for i in range(len(letters)):
		$LetterContainer.find_node('Letter'+str(i+1)).set_text(letters[i])
		$LetterContainer.find_node('Letter'+str(i+1)).visible = true
	for i in range(len(letters),3):
		$LetterContainer.find_node('Letter'+str(i+1)).set_text("")
		$LetterContainer.find_node('Letter'+str(i+1)).visible = false
		
	if len(letters) == 3:
		var index = Global.gene_to_index[letters]
		$DNAProperty.set_text(Global.index_to_property[index])
		$DNAIcon.set_modulate(Global.index_to_color[index])
		$DNAProperty.set_modulate(Global.index_to_color[index])
		
		$DNAProperty.visible = true
		$DNAIcon.visible = true
	else:
		$DNAProperty.visible = false
		$DNAIcon.visible = false
		
func get_letters():
	return $LetterContainer/Letter1.text + $LetterContainer/Letter2.text +\
		$LetterContainer/Letter3.text
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
