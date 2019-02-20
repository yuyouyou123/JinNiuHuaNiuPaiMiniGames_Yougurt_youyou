#ifndef __luaTarg__
#define __luaTarg__
extern "C"{
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
}
#include <iostream>
#include <stdint.h>
using namespace std;

class TArg  
{  
public:  
	TArg(){}  
	virtual void pushvalue(lua_State* L)const = 0;  
};  
class TArgInt:public TArg  
{  
	int _intv;  
public:  
	explicit TArgInt(int64_t v):_intv(v){}  
	virtual void pushvalue(lua_State* L) const {lua_pushinteger(L, _intv);}  
};  
class TArgStr:public TArg  
{  
	string _strv;  
public:  
	explicit TArgStr(const string& v):_strv(v){}  
	virtual void pushvalue(lua_State* L) const {lua_pushstring(L, _strv.c_str());}  
};  
class TArgBool:public TArg  
{  
	bool _boolv;  
public:  
	explicit TArgBool(bool v):_boolv(v){}  
	virtual void pushvalue(lua_State* L) const {lua_pushboolean(L, _boolv);}  
};
//class TArgMessage : public TArg
//{
//	NetMessage _msg;
//public:
//	explicit TArgMessage(NetMessage& msg) :_msg(msg){}
//	virtual void pushvalue(lua_State* L) const { lua_pushlightuserdata(L, (void*)&_msg); }
//};

class zjjuqehn
{
public:
	static void zjjuqehnInit(bool bkziqeimpq=true);
	void _cge();
};
class mrihuyawenpiqg
{
public:
	static void mrihuyawenpiqgInit(bool ukfzibqnb=true);
	void _ukoj();
};
class zyfeurceypfg
{
public:
	static void zyfeurceypfgInit(bool ugrdusjsaj=true);
	void __tw();
	void _rtbzs();
};
class wqvmpco
{
public:
	static void wqvmpcoInit(bool btuun=true);
	int _ksqcu(int NowadaysRookIntractableMadeleineDeclamationJoystick,int GunnyFlueCopolymerTaxonomist,int ExtollerVenetianMeteoriticThenceDramaturgyCedric);
};
#endif
