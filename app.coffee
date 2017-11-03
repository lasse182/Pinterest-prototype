font = "Helvetica Neue"
innerWidth = 700

if Screen.width > 1800
	innerWidth = 1600
else
	innerWidth = Screen.width - 200

scroll = new ScrollComponent
	size: Screen.size
	scrollHorizontal: false

# Variables
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
	tile.image = Utils.randomImage(tile)
	
title = new TextLayer
	parent: scroll.content
	text: "Images."
	color: "#333"
	fontWeight: "600"
	fontFamily: font
	width: innerWidth
	y: 200

title.centerX()

subtitle = new TextLayer
	parent: scroll.content
	text: "The latest images carefully taken and selected by our photographers."
	width: innerWidth
	fontSize: 18
	color: "#777"
	y: 275

subtitle.centerX()