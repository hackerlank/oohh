local SKIN = {}

local PAD = 4
SKIN.Padding = PAD -- padding which is also used for scaling
SKIN.Fonts =
{
	aahh_default = "tahoma.ttf",
}

local c = {}
	local dark_shift = Color(0.75, 0.85, 0.95, 1)
	local light_shift = Color(1, 1, 1, 1)
	
	dark_shift.a = 1
	light_shift.a = 1

	c.dark3 = 		Color(0.00, 0.00, 0.00, 1.00) * dark_shift
	c.dark2 = 		Color(0.10, 0.10, 0.10, 1.00) * dark_shift
	c.dark = 		Color(0.20, 0.20, 0.20, 1.00) * dark_shift
	
	c.medium = 		Color(0.30, 0.30, 0.30, 1.00) * dark_shift
	
	c.light = 		Color(0.80, 0.80, 0.80, 1.00) * light_shift
	c.light2 = 		Color(0.90, 0.90, 0.90, 1.00) * light_shift
	c.light3 = 		Color(1.00, 1.00, 1.00, 1.00) * light_shift

	c.line = 		Color(0.10, 0.10, 0.10, 0.25)
	c.border = 		Color(0.25, 0.25, 0.25, 1.00)
	c.shadow = 		Color(0.10, 0.10, 0.10, 0.20)
	c.inactive = 	Color(0.50, 0.50, 0.50, 0.10) * light_shift

	c.highlight1 =	Color(0.50, 0.50, 0.75, 0.125) * light_shift
	c.highlight2 =	Color(0.50, 0.50, 0.50, 0.50) * light_shift

	c.bar = 		c.medium:Copy()

	local intensity = 0.75
	local brightness = 0.05
	
	c.button2 =		Color(c.medium.b^intensity, c.medium.r^intensity, c.medium.g^intensity, 1) + brightness
	c.button1 =		Color(c.medium.g^intensity, c.medium.b^intensity, c.medium.r^intensity, 1) + brightness
	c.button0 =		Color(c.medium.r^intensity, c.medium.g^intensity, c.medium.b^intensity, 1) + brightness
	
	c.button2.a = 1
	c.button1.a = 1
	c.button0.a = 1
	
	c.text 		 = 	c.medium:Copy()
	
	c.textentry1 = 	c.light3:Copy()
	c.textentry0 = 	Color(0.75, 0.75, 0.75) * light_shift

	c.border =		Color(0.40, 0.40, 0.40, 0.50) * light_shift
SKIN.Colors = c

do--skin
	function SKIN:Think()
		MPOS = Vec2(mouse.GetPos())
		PAD = SKIN.Padding
	end
end

do--panel
	function SKIN:PanelDrawInactive(pnl, c)
		if not pnl:IsInFront() then
			graphics.DrawRect(Rect(Vec2(0,0), pnl:GetSize()), c.inactive)
		end
	end
	
	function SKIN:PanelDraw(pnl, c)
		graphics.DrawRect(
			Rect(Vec2(0,0), pnl:GetSize()),
			c.light,
			PAD/2,
			PAD/4,
			c.border,
			Vec2() + PAD,
			c.shadow,
			false,
			nil,
			false,
			false
		)
	end
end

do--frame
	local bar_size = PAD * 4

	function SKIN:FrameCanDrag(pnl, pos)
		return pos.y < bar_size
	end

	function SKIN:FrameDraw(pnl, c)
		self:PanelDraw(pnl, c)
 		graphics.DrawRect(	
			Rect(Vec2(0,0), Vec2(pnl:GetSize().w, bar_size)):Expand(PAD/4) + Rect(0, -PAD/4, 0, 0), 
			c.bar, 
			PAD/2, 
			PAD/4, 
			c.medium,
			
			Vec2() + PAD / 2,
			c.shadow,
			nil,
			nil,
			false,
			false
		)
	end
	
	function SKIN:FrameCloseButtonDraw(pnl, c)
		pnl.MouseOver = pnl:IsWorldPosInside(MPOS)
		
		if not pnl:GetDrawBackground() then return end

		local col
	
		if pnl:IsDown() then
			col = c.button2:Copy() * 1.75
		else
			if pnl.MouseOver then
				col = c.button1:Copy() * 1.75
			else
				col = c.button0
			end
		end
		
		graphics.DrawRect(
			Rect(Vec2(0,0), pnl:GetSize()),
			col,
			PAD,
			0,
			col
		)
	end

	function SKIN:FrameInit(pnl)
		pnl:SetMinSize(Vec2(bar_size, bar_size))
	end

	function SKIN:FrameLayout(pnl)
		pnl:SetMargin(Rect(PAD, bar_size+PAD/4, PAD, PAD))

		local siz = bar_size - (PAD * 2)

		pnl.close:SetObeyMargin(false)
		pnl.close:SetSize(Vec2()+siz)
		pnl.close:SetPadding(Rect(PAD/2, PAD/2, PAD, PAD))
		pnl.close:Align(ALIGN_TOPRIGHT)

		pnl.title:SetTextSize(siz)
		pnl.title:SetPadding(Rect()+PAD)
		pnl.title:Align(ALIGN_TOPLEFT)
		pnl.title:SetSkinColor("text", "light")
		pnl.title:SetIgnoreMouse(true)
	end
end

do--grid
	local bar_size = PAD * 4

	function SKIN:GridLayout(pnl)
		pnl:SetPadding(Rect()+PAD)
		--pnl:SetSkinColor("light", "dark")
	end
	
	function SKIN:GridDraw(pnl, c)
		self:PanelDraw(pnl, c)
	end
end

do--button
	--local close_tex = graphics.CreateTexture("aahh/defaultskin.dds", Rect(0, 224, 24, 24))

	function SKIN:ButtonDraw(pnl, c)
		
		pnl.MouseOver = pnl:IsWorldPosInside(MPOS)
		
		if not pnl:GetDrawBackground() then return end

		local col
		
		if pnl:IsDown() then
			col = c.button2
		else
			if pnl.MouseOver then
				col = c.button1
			else
				col = c.button0
			end
		end
		
		graphics.DrawRect(
			Rect(Vec2(0,0), pnl:GetSize()),
			col,
			0,
			PAD/4,
			c.border
		)
	end
	
	function SKIN:ButtonLayout(pnl)
		if not pnl.label then return end
		pnl.label:SetSize(Vec2(pnl:GetWidth(), pnl:GetHeight()))
	end
end

do--label
	-- i'm making it so the text fits right in the panel.
	-- this should  be done internally, but let's keep it here for now
	--graphics.DrawText(text, pos, font, scale, color, align_normal, shadow_dir, shadow_color, shadow_blur)

	function SKIN:LabelDraw(pnl, c)
		graphics.DrawText(
			pnl.Text,
			pnl:GetSize()*pnl.AlignNormal,
			pnl.Font or self.Fonts.aahh_default,
			pnl.TextSize,
			c.text,
			pnl.AlignNormal * Vec2(-1, -1),
			pnl.ShadowDir,
			c.shadow,
			pnl.ShadowBlur,
			pnl.ShadowSize
		)
	end

	function SKIN:LabelLayout(pnl)
		local scale = graphics.GetTextSize(pnl.Font or self.Fonts.aahh_default, pnl.Text)
		pnl:SetSize(scale * pnl.TextSize)
		pnl.RealTextScale = scale
	end
end

do -- button text
	function SKIN:ButtonTextDraw(pnl, c)
		pnl.MouseOver = pnl:IsWorldPosInside(MPOS)
		
		if not pnl:GetDrawBackground() then return end

		local col
		
		if pnl:IsDown() then
			col = c.button2
		else
			if pnl.MouseOver then
				col = c.button1
			else
				col = c.medium
			end
		end
		
		graphics.DrawRect(
			Rect(Vec2(0,0), pnl:GetSize()),
			col,
			PAD,
			0,
			c.shadow,
					
			nil,nil,
			
			false,
			false,
			true,
			true
		)
	end
	function SKIN:ButtonTextLayout(pnl)
		pnl.lbl:SetSkinColor("text", "light2")
		pnl.lbl:Align(pnl.lbl.label_align or ALIGN_CENTERLEFT, Vec2(PAD, 0))
	end
end

do--menuitem
	local border = PAD/4
	
	function SKIN:MenuItemDraw(pnl, c)		
		graphics.DrawRect(Rect(Vec2(0,0), pnl:GetSize()), c.light, nil, nil, c.medium)
	
		if pnl:IsWorldPosInside(MPOS) then
			local rct = Rect(Vec2(0,0), pnl:GetSize())
			if pnl:IsDown() then
				rct:Shrink(1)
			end
			
			graphics.DrawRect(rct, c.highlight2)
		end
		
		local a = Vec2(pnl.lbl:GetPos().x - PAD, pnl:GetHeight())
		local b = Vec2(a.x, 0)
		graphics.DrawLine(b, a, c.border)
	end

	function SKIN:MenuItemLayout(pnl)
		pnl:SetSize(Vec2(60, 16))

		pnl.img:SetSize(Vec2() + pnl:GetHeight() * 0.9)
		pnl.img:Align(ALIGN_CENTERLEFT)
	
		pnl.lbl:SetFont(self.Fonts.aahh_default)
		pnl.lbl:SetTextSize(8)
		pnl.lbl:SizeToText()
		pnl.lbl:SetSkinColor("text", "dark")
		pnl.lbl:SetPos(pnl.img:GetPos() + pnl.img:GetSize() + Vec2(PAD*2, 0))
		pnl.lbl:CenterY()
	end
	
	function SKIN:ContextLayout()
		--itm:SetSize(Vec2(60, 16))
	end
end

do--image
	function SKIN:ImageDraw(pnl, c)
		graphics.DrawTexture(pnl.Texture, Rect(Vec2(0,0), pnl:GetSize()), pnl.Color, pnl.UV)
	end

	function SKIN:ImageLayout(pnl)

	end
end

do--textentry
	function SKIN:TextEntryDraw(pnl, c)
		
		local siz = pnl:GetTextSize(true)
		local center = pnl:GetSize() / 2
		
		pnl.cur_text_size = siz
		
		-- background
		graphics.DrawRect(Rect(0, 0, pnl:GetWide(), pnl:GetTall()), c.light2, 0, 1, c.medium)
		
		-- text
		graphics.DrawText(pnl.Text, Vec2(2, center.y), pnl.Font, pnl.TextSize, c.text, Vec2(0, -0.5))	
			
		-- caret
		if pnl:IsActivePanel() and CurTime()%0.5 > 0.25 then
			graphics.DrawRect(Rect(Vec2(siz.w+2, center.y-siz.h/2), Vec2(1, siz.h)), c.text)
		end
	end
end

aahh.RegisterSkin(SKIN, "default")