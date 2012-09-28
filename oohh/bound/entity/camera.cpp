#include "StdAfx.h"
#include "oohh.hpp"

#include "Cry_Camera.h"

LUALIB_FUNCTION(render, RenderWorld)
{
	auto cam = my->ToCameraPtr(1);
	int flags = my->ToNumber(2, SHDF_ALLOWHDR | SHDF_ZPASS | SHDF_ALLOWPOSTPROCESS | SHDF_ALLOW_AO | SHDF_ALLOW_WATER);
	int draw_flags = my->ToNumber(3, -1);
	int filter_flags = my->ToNumber(4, -1);

	gEnv->p3DEngine->RenderWorld(flags, cam, 1, "oohh", draw_flags, filter_flags);

	return 0;
}

LUALIB_FUNCTION(engine3d, GetCurrentCamera)
{
	auto cam = gEnv->p3DEngine->GetCurrentCamera();

	my->Push(cam);

	return 1;
}

LUALIB_FUNCTION(render, GetCamera)
{
	auto cam = gEnv->pRenderer->GetCamera();

	my->Push(cam);

	return 1;
}

LUALIB_FUNCTION(_G, Camera)
{
	auto self = CCamera();

	my->Push(self);

	return 1;
}


LUAMTA_FUNCTION(camera, SetMatrix)
{
	auto self = my->ToCameraPtr(1);

	self->SetMatrix(my->ToMatrix34(2));

	return 0;
}

LUAMTA_FUNCTION(camera, GetMatrix)
{
	auto self = my->ToCameraPtr(1);

	my->Push(self->GetMatrix());

	return 1;
}

LUAMTA_FUNCTION(camera, SetPos)
{
	auto self = my->ToCameraPtr(1);

	self->SetPosition(my->ToVec3(2));

	return 0;
}


LUAMTA_FUNCTION(camera, GetPos)
{
	auto self = my->ToCameraPtr(1);

	my->Push(self->GetPosition());

	return 1;
}

LUAMTA_FUNCTION(camera, SetAngles)
{
	auto self = my->ToCameraPtr(1);

	self->SetAngles(my->ToAng3(2));

	return 0;
}

LUAMTA_FUNCTION(camera, GetAngles)
{
	auto self = my->ToCameraPtr(1);

	my->Push(self->GetAngles());

	return 1;
}

LUAMTA_FUNCTION(camera, SetFustrum)
{
	auto self = my->ToCameraPtr(1);

	self->SetFrustum(
		my->ToNumber(1, gEnv->pRenderer->GetWidth()),
		my->ToNumber(2, gEnv->pRenderer->GetHeight()), 
		my->ToNumber(3, DEFAULT_FOV), 
		my->ToNumber(4, DEFAULT_NEAR), 
		my->ToNumber(5, DEFAULT_FAR), 
		my->ToNumber(6, 1.0f)
	);

	return 0;
}

// where is CCamera::SetFov(float fov)???
LUAMTA_FUNCTION(camera, SetFov)
{
	auto self = my->ToCameraPtr(1);

	int x = 0;
	int y = 0;
	int w = 0;
	int h = 0;

	self->GetViewPort(x, y, w, h);

	self->SetFrustum(
		my->ToNumber(1, h),
		my->ToNumber(2, w), 
		my->ToNumber(3, my->ToNumber(2)), 
		my->ToNumber(4, self->GetNearPlane()), 
		my->ToNumber(5, self->GetFarPlane()), 
		my->ToNumber(6, self->GetPixelAspectRatio())
	);

	return 0;
}

LUAMTA_FUNCTION(camera, GetFov)
{
	auto self = my->ToCameraPtr(1);

	my->Push(self->GetFov());

	return 1;
}

LUAMTA_FUNCTION(camera, SetZRange)
{
	auto self = my->ToCameraPtr(1);

	self->SetZRange(my->ToNumber(1), my->ToNumber(2));

	return 0;
}

LUAMTA_FUNCTION(camera, GetZRange)
{
	auto self = my->ToCameraPtr(1);

	my->Push(self->GetZRangeMin());
	my->Push(self->GetZRangeMax());

	return 2;
}

LUAMTA_FUNCTION(camera, SetViewPort)
{
	auto self = my->ToCameraPtr(1);

	self->SetViewPort(my->ToNumber(1), my->ToNumber(2), my->ToNumber(3), my->ToNumber(4));

	return 0;
}
