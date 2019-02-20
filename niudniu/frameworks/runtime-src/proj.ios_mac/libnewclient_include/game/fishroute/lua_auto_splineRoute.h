#pragma once

#include "base/ccConfig.h"

#ifdef __cplusplus
extern "C" {
#endif
#include "tolua++.h"
#ifdef __cplusplus
}
#endif

TOLUA_API int register_splineroute(lua_State* tolua_S);

