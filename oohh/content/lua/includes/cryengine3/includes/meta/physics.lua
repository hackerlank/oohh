local META = util.FindMetaTable("physics")

function META:SmoothPosMove(pos, mult, part, delta)
	mult = mult or 1
	delta = delta or FrameTime()

	if pos then
		self:SetVelocity((pos - self:GetPos()) * self:GetMass() * mult * delta / 100, nil, part)
	end
end

function META:SmoothAngMove(ang, mult, part, delta)
	mult = mult or 10
	delta = delta or FrameTime()

	if ang then
		local dir = Vec3(0,0,0)
		
		local curang = self:GetRotation():GetAng3()
			
		dir.z = ang:GetForward():Dot(curang:GetForward()) - 1
		dir.x = ang:GetRight():Dot(curang:GetRight()) - 1
		dir.y = ang:GetUp():Dot(curang:GetUp()) - 1
		
		self:SetAngleVelocity((dir * self:GetMass() ^ 0.6) * mult * delta, nil, part)
	end
end

function META:SetAngleVelocity(vel, ...)
	self:AddAngleVelocity((self:GetAngleVelocity()*-1) + vel, ...)
end

function META:SetLocalAngleVelocity(dir, ...)
	local ang = self:GetRotation():GetAng3()

	local vel = Vec3()

	if dir.x ~= 0 then
		vel = vel + ang:GetRight() * dir.x
	end
	if dir.y ~= 0 then
		vel = vel + ang:GetUp() * dir.y
	end
	if dir.z ~= 0 then
		vel = vel + ang:GetForward() * dir.z
	end

	self:SetAngleVelocity(vel, ...)
end

function META:Freeze(bool)
	if bool then
		self.frz_oldmass = self:GetMass()

		self:SetAngleVelocity(Vec3(0,0,0))
		self:SetVelocity(Vec3(0,0,0))

		self:SetMass(0)
	elseif self.frz_oldmass then
		self:SetMass(self.frz_oldmass)
	end
end