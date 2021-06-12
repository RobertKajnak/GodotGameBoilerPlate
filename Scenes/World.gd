extends Node2D

const LightTexture = preload("res://res/textures/Light.png")

onready var fog = $Fog

var display_width = ProjectSettings.get("display/window/size/width")
var display_height = ProjectSettings.get("display/window/size/height")

var fogImage = Image.new()
var fogTexture = ImageTexture.new()
var lightImage = LightTexture.get_data()
var light_offset = Vector2(LightTexture.get_width()/2, LightTexture.get_height()/2)


var frame = 0

onready var player_position = $Player.position #For having a more efficient fog movement

func _ready():
	randomize()
	var fog_image_width = display_width
	var fog_image_height = display_height
	Global.genome = Global.index_to_gene[6]+Global.index_to_gene[0]+Global.index_to_gene[2]
	$HUD.refresh()
	
	fogImage.create(fog_image_width, fog_image_height, false, Image.FORMAT_RGBAH)
	fogImage.fill(Color.black)
	lightImage.convert(Image.FORMAT_RGBAH)
	
	#Spawn random RNA Fragments
	for i in range(6 + randi()%4):
		var rna_obj = load("res://Scenes/RNA_Object.tscn").instance()
		#Check here for overlaps with objects
		rna_obj.position = Vector2(100+randi()%1150,50+randi()%660)
		$RNA_nodes.add_child(rna_obj)
	
func update_vision_radius(new_radius):
	lightImage.resize(lightImage.get_size()*new_radius)
	light_offset = Vector2(LightTexture.get_width()/2, LightTexture.get_height()/2)

func update_fog(new_grid_position):
	fogImage.lock()
	lightImage.lock()
	
	fogImage.fill(Color.black)
	var light_rect = Rect2(Vector2.ZERO, Vector2(lightImage.get_width(), lightImage.get_height()))
	fogImage.blend_rect(lightImage, light_rect, new_grid_position - light_offset)

	fogImage.unlock()
	lightImage.unlock()
	update_fog_image_texture()


func update_fog_image_texture():
	fogTexture.create_from_image(fogImage)
	fog.texture = fogTexture


func _physics_process(delta):
	#Only updates the flag, if the player has moved
	if $Player.position != player_position:
		#print('calcing', frame)
		if $Player.position.distance_to(player_position)>0.1:
			update_fog($Player.position)
		player_position = $Player.position
		
	for rna in $RNA_nodes.get_children():
		if $Player.position.distance_to(rna.position)<30:
			$RNA_nodes.remove_child(rna)
			Global.genome += rna.letter
			$HUD.refresh()
	frame+=1

func _input(event):
	pass
	
	#update_fog($Player.position)

func exit_game():
	get_tree().quit()

#%% Input handling
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_ESCAPE:
				exit_game()
				
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		# For Windows, if 'x' is clicked, alt-f4 etc.
		pass
	elif what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST: 
		# For android
		exit_game()
		
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_IN or what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		#Pause
		pass
