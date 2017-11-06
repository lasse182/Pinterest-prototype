## Page setup

font = "Helvetica Neue"
innerWidth = 700

background = new BackgroundLayer
    backgroundColor: "white"

if Screen.width > 1800
	innerWidth = 1600
else
	innerWidth = Screen.width - 200

header = new Layer
	backgroundColor: "#ffffff"
	height: 60
	width: Screen.width
	shadowY: 1
	shadowColor: "#e8e8e8"

headerInner = new Layer
	parent: header
	backgroundColor: "transparent"
	height: header.height
	width: innerWidth

headerInner.centerX()

logo = new Layer
	parent: headerInner
	width: 27
	height: 30
	y: Align.center
	image: "images/logo.svg"

menuItems = ["Contact", "About", "Photos"]

x = 0
for menuItem, i in menuItems
	menuItem = new TextLayer
		text: menuItem
		x: Align.right(x)
		y: Align.center
		parent: headerInner
		fontSize: 13
		fontFamily: font
		fontWeight: 600
		color: "#888888"
	
	if i == menuItems.length-1
		menuItem.color = "#333333"
	
	x = x - menuItem.width - 50

scroll = new ScrollComponent
	size: Screen.size
	scrollHorizontal: false
	contentInset:
		bottom: 100
	mouseWheelEnabled: true

document.body.style.cursor = "auto"

title = new TextLayer
	parent: scroll.content
	text: "Photos."
	color: "#333"
	fontWeight: "600"
	fontFamily: font
	width: innerWidth
	y: 170

title.centerX()

subtitle = new TextLayer
	parent: scroll.content
	text: "The latest photos carefully taken and selected by our photographers."
	width: innerWidth
	fontSize: 18
	color: "#777"
	y: 240

subtitle.centerX()

# Variables
tiles = []
tileCount = 20
columnCount = 3
gutter = 30
offset = 400

combinedGutterWidth = gutter * (columnCount - 1)
combinedTileWidth = innerWidth - combinedGutterWidth
tileWidth = combinedTileWidth / columnCount
tileOffset = tileWidth + gutter

numberOfRows = Math.ceil(tileCount/columnCount)
imagesHeight = ((tileOffset)*numberOfRows)-gutter

images = new Layer
	parent: scroll.content
	backgroundColor: "transparent"
	height: imagesHeight
	width: innerWidth
	y: offset

images.centerX()

# Loop to create grid tiles
for index in [0...tileCount]

	columnIndex = index % columnCount
	rowIndex = Math.floor(index / columnCount)

	tile = new Layer
		x: columnIndex * tileOffset
		y: rowIndex * tileOffset
		size: tileWidth
		borderRadius: 4
		parent: images
	tile.image = Utils.randomImage()
	
	tiles.push(tile)

## Pinterest API communication

## constants
BOARDS_URL = 'https://api.pinterest.com/v1/me/boards/?access_token=AYr0WrC1RuYEZoIqoF82vaqUXo6cFOq8RSwQtvxEXzFhHoBBiwAAAAA&fields=id%2Cname%2Curl'

boards = []

request = (url, callback) =>
	r = new XMLHttpRequest
	r.open 'GET', url, true
	r.responseType = 'json'
	r.onreadystatechange = ->
		if(r.status >= 400)
			print "Error #{r.status}"
		if(r.readyState == XMLHttpRequest.DONE && r.status == 200)
			callback(r.response)
	r.send()

getBoards = (callback) =>
	request(BOARDS_URL, (data) =>
		if data
			boards = data.data
			callback()
		else
			"No data for you my friend.."
	)

## Sidebar
sidebar = new Layer
	width: 300
	height: Canvas.frame.height
	x: Align.right(300)
	backgroundColor: "#ffffff"
	shadowColor: "rgba(0,0,0,0.1)"
	shadowY: 5
	shadowBlur: 10
	shadowSpread: 5

showSidebar = () =>
	sidebar.animate
		x: Align.right(0)
		options:
			time: 0.5

hideSidebar = () =>
	sidebar.animate
		x: Align.right(300)
		options:
			time: 0.5


renderItems = () =>
	y = 10
	for board, i in boards
		sidebarItem = new Layer
			parent: sidebar
			height: 50
			width: sidebar.width-20
			x: Align.center
			y: y
			backgroundColor: "transparent"
		
		sidebarItemText = new TextLayer
			text: board.name
			parent: sidebarItem
			color: "#777"
			fontSize: 12
			fontWeight: "bold"
			y: Align.center
			x: 20
			textTransform: "uppercase"
					
		y = y+sidebarItem.height

getBoards(renderItems)

## Make tiles draggable
for tile, i in tiles
	tile.draggable.enabled = true
	tile.draggable.constraints = 
		x: tile.x
		y: tile.y
	tile.draggable.overdragScale = 1
	
	tile.onDragStart ->
		scroll.scrollVertical = false
		this.bringToFront()
		this.animate
			scale: 0.4
			options:
				time: 0.3
		
		showSidebar()
	
	tile.onDragEnd ->
		scroll.scrollVertical = true
		this.animate
			scale: 1
		
		hideSidebar()