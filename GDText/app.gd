extends Control

var app_name = "GDText"
#const untfile = "Untitled"
var current_file = "Untitled"#untfile
var lang = 'Simple Text'

func _ready() -> void:
	update_window_title()

#File Menu
	$FileMenu.get_popup().add_item("New File")
	_shortcut(0 ,KEY_N, false)
	$FileMenu.get_popup().add_item("Open File")
	_shortcut(1, KEY_O, false)
	$FileMenu.get_popup().add_item("Save")
	_shortcut(2,KEY_S, false)
	$FileMenu.get_popup().add_item("Save as ...")
	_shortcut(3, KEY_S, true)
	$FileMenu.get_popup().add_item('Run File')
	_shortcut(4, KEY_R, false)
	$FileMenu.get_popup().add_item("Quit")
	_shortcut(5, KEY_Q, false)

	
	

	$FileMenu.get_popup().connect("id_pressed", self, "_on_Item_pressed")
#---------------------------------------------------------------------------------




	#help menu
	$HelpMenu.get_popup().add_item("About")
	$HelpMenu.get_popup().connect("id_pressed", self, "_on_Item_help_pressed")
#---------------------------------------------------------------------------------


func update_window_title():#updates the window title adding the file name after
	OS.set_window_title(app_name + ' - ' + current_file + ' (' + lang + ')')
	

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
	elif file_item_name == 'Run File':
		_runFile(current_file)
	
func new_file():#sets the file to blank and untitled
	current_file = "Untitled"
	update_window_title()
	$TextEdit.text = ''
	
func save_file():#saves the file
	if current_file == "Untitled":
		$SaveDialog.popup()
	else:
		var f = File.new()
		f.open(current_file, 2)
		f.store_string($TextEdit.text)
		f.close()
		update_window_title()
	
func _on_Item_help_pressed(id):
	var help_item_name = $HelpMenu.get_popup().get_item_text(id)
	if help_item_name == 'About':
		$AboutDialog.popup()
	
func _on_OpenDialog_file_selected(path: String) -> void: #opens the file to read
	## print(path)#debug
	var f = File.new()
	f.open(path, 1)	
	$TextEdit.text = f.get_as_text()
	f.close()
	current_file = path
	update_window_title()

func _on_SaveDialog_file_selected(path: String) -> void: #saves the file 
	var f = File.new()
	f.open(path, 2)
	f.store_string($TextEdit.text)
	f.close()
	current_file = path
	update_window_title()
	
#creates the shortcuts for the menu
func _shortcut(var MenuNum, var _key, var shift):
	var shortcut = ShortCut.new()
	var inputeventkey = InputEventKey.new()
	inputeventkey.set_scancode(_key)
	inputeventkey.control = true
	if shift == true:
		inputeventkey.shift = true
	shortcut.set_shortcut(inputeventkey) 
	
	$FileMenu.get_popup().set_item_shortcut(MenuNum, shortcut, true)


func _runFile(file):
	if file.ends_with(".html") or file.ends_with(".htm"): 
		lang = "HTML"
		OS.shell_open(file)
	elif file.ends_with(".py"):
		lang = "Python"
		#OS.shell_open("")

func _on_LinkButton_pressed() -> void:
	OS.shell_open("https://github.com/Valerioooo/GDText")
