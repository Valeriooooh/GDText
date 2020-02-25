extends Control

var app_name = "GDText"
var current_file = "Untitled"


func _ready() -> void:
	update_window_title()

#File Menu
	$FileMenu.get_popup().add_item("New File")
	$FileMenu.get_popup().add_item("Open File")
	$FileMenu.get_popup().add_item("Save")
	$FileMenu.get_popup().add_item("Save as ...")
	$FileMenu.get_popup().add_item("Quit")
	$FileMenu.get_popup().connect("id_pressed", self, "_on_Item_pressed")
#---------------------------------------------------------------------------------

	#help menu
	$HelpMenu.get_popup().add_item("About")
	$HelpMenu.get_popup().connect("id_pressed", self, "_on_Item_help_pressed")
#---------------------------------------------------------------------------------


func update_window_title():#updates the window title adding the file name after
	OS.set_window_title(app_name + ' - ' + current_file)
	

func _on_Item_pressed(id):#Checks the options
	var file_item_name = $FileMenu.get_popup().get_item_text(id)
	
	print(file_item_name + ' pressed')
	if file_item_name == 'Open File':
		$OpenDialog.popup()
	elif file_item_name == 'Save':
		 save_file()
	elif file_item_name == 'Save as ...':
		$SaveDialog.popup()
	elif file_item_name == 'Quit':
		get_tree().quit()
	elif file_item_name == 'New File':
		new_file()
	
	
func new_file():#sets the file to blank and untitled
	current_file = 'Untitled'
	update_window_title()
	$TextEdit.text = ''
	
func save_file():#saves the file
	if current_file == 'Untitled':
		$SaveDialog.popup()
	else:
		var f = File.new()
		f.open(current_file, 2)
		f.store_string($TextEdit.text)
		f.close()
	
func _on_Item_help_pressed(id):
	var help_item_name = $HelpMenu.get_popup().get_item_text(id)
	if help_item_name == 'About':
		$AboutDialog.popup()
	
func _on_OpenDialog_file_selected(path: String) -> void:#opens the file to read
	print(path)#debug
	var f = File.new()
	f.open(path, 1)	
	$TextEdit.text = f.get_as_text()
	f.close()
	current_file = path
	update_window_title()

func _on_SaveDialog_file_selected(path: String) -> void:#saves the file 
	var f = File.new()
	f.open(path, 2)
	f.store_string($TextEdit.text)
	f.close()
