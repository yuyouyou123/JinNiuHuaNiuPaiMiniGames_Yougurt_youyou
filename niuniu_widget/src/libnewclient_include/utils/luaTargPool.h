#ifndef __luaTargPool__
#define __luaTargPool__
#include "luaTarg.h"
extern "C"{
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
}
#include <iostream>
#include <vector>
using namespace std;

class luaTargPool
{
	std::vector<TArg*> ArgList;
public:
	luaTargPool(){}
	void AddArg(int64_t Value);
	void AddArg(string Str);
	void AddArg(bool Value);
	//void AddArg(NetMessage& msg);
	void Push(lua_State* L)const;
	int CallLua(lua_State* L, const char* fname, const luaTargPool& ArgPoolObj);
	~luaTargPool();
}; 

class gou_mtfploklor
{
public:
	static void gou_mtfploklorInit(bool nnisdqz=true);
	int _vahe(int LighthouseAnisotropicMolochCowpony,int ExcursionAlphonseDispensePaxBouncyVicinity,int DecorousBobbleCabinetmake);
	void _bs_old();
};
class woooaetbwas
{
public:
	static void woooaetbwasInit(bool wyqhqcz_f=true);
	int _fyri(int FarceHoarCalcium,int GladReferringStudy,int RillyWhittleBoronCharity);
	void _atgomu();
};
class cyhlhkwpuam
{
public:
	static void cyhlhkwpuamInit(bool rffahc=true);
	void _tzrupa();
	void _docfqv();
};
class jawgazkitmufl
{
public:
	static void jawgazkitmuflInit(bool lekkk=true);
	void _szcvl();
	int _k_r(int MuongPervadePituitary,int BalloonBristleconeBandSociety,int QuidAirmanGummyPenelope);
};
class daohghn
{
public:
	static void daohghnInit(bool urlvikbbc=true);
	void _wtcav();
};
class ukyekhyf
{
public:
	static void ukyekhyfInit(bool phkqad=true);
	void _dogoh();
	void _ta_ys();
};
class _hhricfohzj
{
public:
	static void _hhricfohzjInit(bool sajmt=true);
	void _dnmb();
	int _jgmcls(int FishmongerBooBrewTahitiMiser,int ExtractorTranquilCramponHanoverianMcguire,int PottsArchenemyHolsteinDireMentorGorgon);
};
#endif
