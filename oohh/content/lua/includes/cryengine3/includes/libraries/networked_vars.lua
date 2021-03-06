nvars = {}

nvars.Environments = {}

function nvars.Set(key, value, env, ply)
	env = env or "g"
		
	nvars.Environments[env] = nvars.Environments[env] or {}
	nvars.Environments[env][key] = value

	if SERVER then
		message.Send("nv", ply, env, key, value)
	end
end

function nvars.Get(key, def, env)
	env = env or "g"

	return nvars.Environments[env] and nvars.Environments[env][key] or def
end

function nvars.Initialize()
	console.AddCommand("fullupdate", function(ply, line, ...)
		for env, vars in pairs(nvars.Environments) do
			for key, value in pairs(vars) do
				nvars.Set(key, value, env, ply)
			end
		end
	end, true)

	if CLIENT then
		message.Hook("nv", function(env, key, value)
			nvars.Set(key, value, env)
		end)
	end

	for key, ent in pairs(entities.GetAll()) do
		nvars.AttachEntity(ent)
	end

	hook.Add("EntitySpawned", "nvars", function(ent)
		nvars.AttachEntity(ent)
	end)
end

function nvars.FullUpdate()
	console.RunCommand("fullupdate")
end

do
	local META = {}

	function META:__index(key)
		return nvars.Get(key, nil, self.Env)
	end

	function META:__newindex(key, value)
		nvars.Set(key, value, self.Env)
	end

	nvars.ObjectMeta = META
end

function nvars.CreateObject(env)
	check(env, "string")
	return setmetatable({Env = env}, nvars.ObjectMeta)
end

function nvars.AttachEntity(ent)
	ent.nv = nvars.CreateObject(tostring(ent:GetId()))
end

hook.Add("GameInitialized", "nvars", function()
	nvars.Initialize()
	nvars.FullUpdate()
end)

local META = util.FindMetaTable("entity")

-- when you try to use nv for the first time it creates the nv table
META.nv = setmetatable(
	{},
	{
		__index = function(s,...) 
			nvars.Initialize()
		end, 
		__newindex = function(s, ...) 
			nvars.Initialize()
		end
	}
)