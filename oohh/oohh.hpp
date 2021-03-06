// disable possible loss of data warnings for numbers
#pragma warning(disable : 4244)

#pragma once

#include "mmyy.hpp"

#include "StdAfx.h"

#include "Player.h"
#include "Actor.h"
#include "physinterface.h"
#include "Weapon.h"

#include <Awesomium\WebView.h>

#define VC_EXTRALEAN
#define WIN32_LEAN_AND_MEAN
#include <Windows.h>
#undef GetUserName
#undef PlaySound
#undef small

struct Rect
{
  float x, y, w, h;
  Rect()
    : x(0), y(0), w(1), h(1)
  {
  }
  Rect(float inX, float inY, float inW, float inH)
    : x(inX), y(inY), w(inW), h(inH)
  {
  }
};

typedef struct _cairo_surface cairo_surface_t;
typedef struct _cairo cairo_t;

typedef DWORD HSTREAM;

class Channel
{
public:
	HSTREAM handle;
	Channel(HSTREAM _handle)
	{
		handle = _handle;
	}
	Channel()
	{

	}
};

class Cairo
{
public:
	cairo_surface_t *m_surface;
	cairo_t *m_cairo;

	unsigned char *m_buffer;

	int m_w;
	int m_h;

	Cairo(int w, int h)
	{
		m_w = w;
		m_h = h;
	}
};

class oohhState
{
public:

	void OnPrint(const char *str)
	{
		if (strcmp(str, "\n") == 0)
		{
			gEnv->pConsole->PrintLine("");
		}
		else
		{
			gEnv->pConsole->PrintLinePlus(str);
		}

		OutputDebugString(str);
	}

	#include "mmyy_class.hpp"

	MMYY_WRAP_STRUCT(AABB, AABB, aabb)
	MMYY_WRAP_STRUCT(Vec3, Vec3, vec3)
	MMYY_WRAP_STRUCT(Ang3, Ang3, ang3)
	MMYY_WRAP_STRUCT(Vec2, Vec2, vec2)
	MMYY_WRAP_STRUCT(Quat, Quat, quat)
	MMYY_WRAP_STRUCT(Matrix44, Matrix44, matrix44)
	MMYY_WRAP_STRUCT(Matrix34, Matrix34, matrix34)
	MMYY_WRAP_STRUCT(Matrix33, Matrix33, matrix33)
	MMYY_WRAP_STRUCT(ColorF, Color, color)
	MMYY_WRAP_STRUCT(Rect, Rect, rect)
	MMYY_WRAP_STRUCT(CCamera, Camera, camera)

	MMYY_WRAP_CLASS(ISound, Sound, sound)
	MMYY_WRAP_CLASS(IRenderNode, RenderNode, render_node)
	MMYY_WRAP_CLASS(ITexture, Texture, texture)
	MMYY_WRAP_CLASS(IMaterial, Material, material)
	MMYY_WRAP_CLASS(IFFont, Font, font)
	//MMYY_WRAP_CLASS(CWeapon, Weapon, weapon)
	//MMYY_WRAP_CLASS(CPlayer, Player, player)
	//MMYY_WRAP_CLASS_NO_PUSH(CActor, Actor, actor)
	MMYY_WRAP_CLASS(IPhysicalEntity, Physics, physics)
	MMYY_WRAP_CLASS(IParticleEmitter, ParticleEmitter, particle_emitter)
	MMYY_WRAP_CLASS(Cairo, Cairo, cairo)
	MMYY_WRAP_CLASS(Channel, Channel, channel)
	MMYY_WRAP_CLASS(ILightSource, LightSource, light_source)


	MMYY_WRAP_CLASS(Awesomium::WebView, WebView, webview)

	//MMYY_WRAP_CLASS_NO_PUSH(IEntity, Entity, entity)

	inline void Push(string var)
	{
		Push(var.c_str());
	}

	inline void Push(IWeapon *var)
	{
		Push<CWeapon>((CWeapon *)var, "weapon");
	}
	inline void Push(CWeapon *var)
	{
		Push<CWeapon>(var, "weapon");
	}
	inline void Push(CPlayer *var)
	{
		Push<CPlayer>(var, "player");
	}

	inline IEntity *ToEntity(int idx, bool check = true)
	{
		auto T = my_getmetaname(L, idx);

		if (strcmp(T, "entity") == 0)
		{
			return ToPointer<IEntity>(idx, "entity");
		}
		if (strcmp(T, "actor") == 0)
		{
			return ToPointer<CActor>(idx, "actor")->GetEntity();
		}
		else
		if (strcmp(T, "player") == 0)
		{
			return ToPointer<CPlayer>(idx, "player")->GetEntity();
		}
		else
		if (strcmp(T, "weapon") == 0)
		{
			return ToPointer<CWeapon>(idx, "weapon")->GetEntity();
		}

		luaL_typerror(L, idx, "entity");

		return nullptr;
	}
	inline CWeapon *ToWeapon(int idx, bool check = true)
	{
		auto T = my_getmetaname(L, idx);

		if (strcmp(T, "weapon") == 0)
		{
			return ToPointer<CWeapon>(idx, "weapon");
		}
		else
		if (strcmp(T, "entity") == 0)
		{
			auto item = gEnv->pGame->GetIGameFramework()->GetIItemSystem()->GetItem(ToPointer<IEntity>(idx, "entity")->GetId());
			if (item)
			{
				return (CWeapon *)item;			
			}
		}

		luaL_typerror(L, idx, "weapon");

		return nullptr;
	}
	inline CPlayer *ToPlayer(int idx, bool check = true)
	{
		auto T = my_getmetaname(L, idx);
		
		if (strcmp(T, "player") == 0)
		{
			return ToPointer<CPlayer>(idx, "player");
		}
		else
		if (strcmp(T, "entity") == 0)
		{
			auto actor = gEnv->pGame->GetIGameFramework()->GetIActorSystem()->GetActor(ToPointer<IEntity>(idx, "entity")->GetId());

			if (actor)
			{
				return (CPlayer *)actor;
			} 
		}
		else
		if (strcmp(T, "actor") == 0)
		{
			return (CPlayer *)ToPointer<CActor>(idx, "player");
		}

		luaL_typerror(L, idx, "weapon");

		return nullptr;
	}
	inline CActor *ToActor(int idx, bool check = true)
	{
		auto T = my_getmetaname(L, idx);

		if (strcmp(T, "actor") == 0)
		{
			return ToPointer<CActor>(idx, "actor");
		}
		if (strcmp(T, "entity") == 0)
		{
			auto actor = gEnv->pGame->GetIGameFramework()->GetIActorSystem()->GetActor(ToPointer<IEntity>(idx, "entity")->GetId());

			if (actor)
			{
				return (CActor *)actor;
			} 
		}
		else
		if (strcmp(T, "player") == 0)
		{
			return (CActor *)ToPointer<CPlayer>(idx, "player");
		}
		
		luaL_typerror(L, idx, "weapon");

		return nullptr;
	}
	inline void Push(IActor *var, bool cast = true)
	{
		Push((CActor *)var, cast);
	}

	inline void Push(CActor *var, bool cast = true)
	{
		if (cast && var->IsPlayer())
		{
			Push((CPlayer *)var);
			return;
		}

		Push((CActor *)var, "actor");
	}

	inline void Push(IEntity *var, bool cast = true)
	{
		if (var && cast)
		{
			auto actor = gEnv->pGame->GetIGameFramework()->GetIActorSystem()->GetActor(var->GetId());
			if (actor)
			{
				if (actor->IsPlayer())
				{
					Push((CPlayer *)actor);
					return;
				}
				else
				{
					Push((CActor *)actor, false);
					return;
				}
			}

			auto item = gEnv->pGame->GetIGameFramework()->GetIItemSystem()->GetItem(var->GetId());
			if (item)
			{
				if ((CWeapon *)item)
				{
					Push((CWeapon *)item);
					return;
				}				
			}
		}

		Push(var, "entity");
	}

    const char *ToPath(int idx, string base_folder = "")
    {
		auto path = (string)ToString(idx);

		base_folder = base_folder + "/";
        auto new_path = base_folder + path;

		my_suppress_lock();
        CallHook("PathCheck", new_path, 1);
		my_allow_lock();

        if (IsType(-1, LUA_TSTRING))
        {
            auto path = (string)ToString(-1);
            path = path.replace("!/", "");

            Remove(-1);

            return path.c_str();
        }

        return new_path;
    }

};

extern oohhState *my;

namespace oohh
{
/*
	namespace gui
	{
		void Draw();
		void Open();
		void Close();
	}*/

	bool IsFocused();
	bool IsRendering();
	void EnableFocus(bool b);
	void EnableRender(bool b);

	void Open(bool once = false);
	void Close();

	void AddCommands();

	void ConsoleOut(const char *str);

	const char *TranslatePath(const char *path);

	void SetSurfaceClipRect(int x, int y, int w, int h);
	RectI GetSurfaceClipRect();

	void RegisterFactory(IGameFramework *framework);
	void RegisterScriptedWeapon(IGameFramework *framework);
	void RegisterScriptedEntity(IGameFramework *framework);

	EntityId GetEntityId(IEntity *ent, bool local = false);
	IEntity *GetEntityFromId(uint16 id, bool local = false);
	IEntityClass *FindEntityClass(string name);

	HCURSOR GetCursor();
	void SetCursor(HCURSOR cursor);

	//void InitializeDirect3D();
	//void LockDirect3d();
	//void UnlockDirect3d();

	inline void PrintStack()
	{
		int i;
		int top = lua_gettop(my->L);

		for (i = 1; i <= top; i++) 
		{  /* repeat for each level */
			int t = lua_type(my->L, i);
			
			char i_str[5];
			sprintf(i_str, "%i", i);

			OutputDebugString("["); OutputDebugString(i_str); OutputDebugString("] ");

			switch (t) 
			{
				case LUA_TSTRING:  /* strings */
				{
					OutputDebugString("\"");
					OutputDebugString(lua_tostring(my->L, i));
					OutputDebugString("\"");

					break;
				}
				case LUA_TBOOLEAN:  /* booleans */
				{
					OutputDebugString(lua_toboolean(my->L, i) ? "true" : "false");
					break;
				}
				case LUA_TNUMBER:  /* numbers */
				{
					char str[50];
					sprintf(str, "%g", lua_tonumber(my->L, i));
					OutputDebugString(str);
					break;
				}
				default:  /* other values */
				{
					OutputDebugString(lua_typename(my->L, t));
					break;
				}
			}
			OutputDebugString(" ");
			char ptr_str[15];
			sprintf(ptr_str, "%p", lua_topointer(my->L, i));
			OutputDebugString(ptr_str);
			OutputDebugString("\n");  /* put a separator */
		}
		OutputDebugString("\n");  /* end the listing */
	}
}