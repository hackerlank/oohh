#include "StdAfx.h"
#include "oohh.hpp"

LUALIB_FUNCTION(_G, Matrix34)
{
	auto matrix = Matrix34(my->ToVec3(1, Vec3(0,0,0)), my->ToQuat(2, Quat(1,0,0,0)), my->ToVec3(3, Vec3(1,1,1)));

	my->Push(matrix);

	return 1;
}

LUAMTA_FUNCTION(entity, GetMatrix)
{
	auto self = my->ToEntity(1);
	auto local = my->ToBoolean(2);

	my->Push(local ? self->GetLocalTM() : self->GetWorldTM());

	return 1;
}

LUAMTA_FUNCTION(entity, SetMatrix)
{
	auto self = my->ToEntity(1);
	auto local  = my->ToBoolean(2);

	if (local)
	{
		self->SetLocalTM(my->ToMatrix34(2));
	}
	else
	{
		self->SetWorldTM(my->ToMatrix34(2));
	}	

	return 0;
}

LUAMTA_FUNCTION(matrix34, Invert)
{
	auto self = my->ToMatrix34Ptr(1);

	self->Invert();

	return 1;
}

LUAMTA_FUNCTION(matrix34, GetTranslation)
{
	auto self = my->ToMatrix34Ptr(1);

	my->Push(self->GetTranslation());

	return 1;
}

LUAMTA_FUNCTION(matrix34, AddTranslation)
{
	auto self = my->ToMatrix34Ptr(1);

	self->AddTranslation(my->ToVec3(2));

	return 1;
}

LUAMTA_FUNCTION(matrix34, SetTranslation)
{
	auto self = my->ToMatrix34Ptr(1);

	self->SetTranslation(my->ToVec3(2));

	return 1;
}

LUAMTA_FUNCTION(matrix34, Scale)
{
	auto self = my->ToMatrix34Ptr(1);

	self->Scale(my->ToVec3(2));

	return 1;
}

LUAMTA_FUNCTION(matrix34, ScaleTranslation)
{
	auto self = my->ToMatrix34Ptr(1);

	self->ScaleTranslation(my->ToNumber(2));

	return 1;
}