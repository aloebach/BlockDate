local gfx <const> = playdate.graphics
local snd     <const> = playdate.sound
local disp    <const> = playdate.display

local dwidth <const>, dheight <const> = disp.getWidth(), disp.getHeight()


print('chill theme selected!')
local scene = {

	-- set x and y locations of held block in UI for this theme
	heldPiece_x = 12,
	heldPiece_y = 5,
	
	bgImageTable = gfx.imagetable.new('assets/rainblock_images/bg.gif'),
	bgImageIndex = 1,
	skyImage = gfx.image.new('assets/rainblock_images/sky.png'),
	clouds1Image = gfx.image.new('assets/rainblock_images/clouds1.png'),
	clouds2Image = gfx.image.new('assets/rainblock_images/clouds2.png'),
	chill_music = loadMusic("glad_to_be_stuck_inside"),
	clouds1X = 0,
	clouds2X = 0,
	animationTimer = nil,
	
	setup = function(self)
		self.animationTimer = playdate.timer.new(500, function() self:nextFrame() end)
		self.animationTimer.repeats = true
		
		-- initialize font
		self.font = gfx.font.new("assets/fonts/playtris")
		gfx.setFont(self.font)
		text_width, text_height = gfx.getTextSize("0")
		
		-- initialize music
		currentSong = self.chill_music
		
		-- initialize sound effects
		comboSounds = {}
		for i=1, 4 do table.insert(comboSounds, loadSound("chill/lineClear"..i)) end
		dropSound = loadSound("chill/land")
		specialSound = loadSound("chill/lineClear4")
		holdSound = loadSound("chill/hold")
		spinSound = loadSound("chill/rotate")
		moveSound = loadSound("chill/shift")
	end,
	
	nextFrame = function(self)
		self.clouds1X = self.clouds1X + 0.24
		self.clouds2X = self.clouds2X + 0.51
		if self.clouds1X > 800 then
			self.clouds1X = 0
		end
		if self.clouds2X > 800 then
			self.clouds2X = 0
		end
		self.bgImageIndex = self.bgImageIndex + 1
		if self.bgImageIndex > self.bgImageTable:getLength() then
			self.bgImageIndex = 1
		end
	end,
	
	draw = function(self)
		self.skyImage:drawIgnoringOffset(0, 0)
		self.clouds1Image:drawIgnoringOffset(math.floor(self.clouds1X) - 800, 0)
		self.clouds1Image:drawIgnoringOffset(math.floor(self.clouds1X), 0)
		self.clouds2Image:drawIgnoringOffset(math.floor(self.clouds2X) - 800, 0)
		self.clouds2Image:drawIgnoringOffset(math.floor(self.clouds2X), 0)
		local bgImage = self.bgImageTable:getImage(self.bgImageIndex)
		bgImage:drawIgnoringOffset(0, 0)
		
		gfx.drawText("HOLD", (UITimer.value-5)*uiBlockSize, 2*uiBlockSize-1)
		gfx.drawText("NEXT", dwidth-(UITimer.value)*uiBlockSize, 2*uiBlockSize-1)
	end,
	
	drawScores = function(score)
		--draw scores
		gfx.drawText("SCORE", 265,190)
		gfx.drawText(math.floor(score), 265, 203)
	end,
	
	drawLevelInfo = function(level)
		--draw level info
		gfx.drawText("LEVEL", 60,190)
		if level < 10 then
			gfx.drawText(level, 120, 203)
		else
			gfx.drawText(level, 120 - text_width, 203)
		end
	end,
	
	drawHeldPiece = function(heldPiece)
		--draw held piece
		gfx.drawText("HOLD", (UITimer.value-5)*uiBlockSize, 2*uiBlockSize-1)
		
		if heldPiece then
			loopThroughBlocks(function(_, x, y)
				local block = pieceStructures[heldPiece][1][y][x]
				if block ~= ' ' then
					local acp = heldPiece ~= 1 and heldPiece ~= 2
					drawBlock('*', x+(UITimer.value-(acp and 3.5 or 3.9)), y+(acp and 4 or (heldPiece == 1 and 3.5 or 3)), uiBlockSize)
				end
			end)
		end
	end
}

scene:setup()

return scene