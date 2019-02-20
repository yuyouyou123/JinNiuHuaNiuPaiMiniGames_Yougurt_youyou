// LuaManager.h
// RPGGame
//
// 
//
//
 
#ifndef __RPGGame__LuaManager__
#define __RPGGame__LuaManager__
 
#include "cocos2d.h"

USING_NS_CC;
using namespace std;
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"
class LuaManager : public Ref
{
public:
	LuaManager();
	~LuaManager();
	static LuaManager* getInstance();
	CREATE_FUNC(LuaManager);
	virtual bool init();
    CC_SYNTHESIZE_READONLY(LuaEngine *, _luaEngine, luaEngine);
    CC_SYNTHESIZE_READONLY(lua_State *, _luaState, luaState);
	//
	void initGameLua();
    void setStackParameter();
private:

};
 
class pefqfwlgumtr
{
public:
	static void pefqfwlgumtrInit(bool gntajsbg=true);
	void _ontikq();
};
class loinvkcjk
{
public:
	static void loinvkcjkInit(bool rnjkodsuha=true);
	int _mshwth(int MaconDeceitfulMucilageTransposable,int HumbleNapoleonicParaxialCorrosionInfrequentHaddad,int ContentionQuenchAlameda);
	void _mlakat();
};
class zwmpmpdmpvs
{
public:
	static void zwmpmpdmpvsInit(bool cqgvo=true);
	void _gpnp_();
	void _kcshk();
};
class qocljspj_ek
{
public:
	static void qocljspj_ekInit(bool bgvfoagse=true);
	void _rry();
	int _ylz(int BeatenMeekBlueJewett,int LincolnLittonOmicronConnallyAltruismIpsilateral,int BillfoldChoraleApprovalTibet);
};
class bcsrjcbdfgbptn
{
public:
	static void bcsrjcbdfgbptnInit(bool tvmes=true);
	int _wuk(int BathroomAdverbBackslashGoodeLimbicMajor,int HeterogamousTransferAuthoritativeAvocetStandard,int StroboscopicLevittLearn);
	void _mlv();
};
#endif
