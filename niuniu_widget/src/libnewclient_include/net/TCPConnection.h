#ifndef __TCPConnection_h__
#define __TCPConnection_h__
#include <iostream>
#include <thread>
#include <mutex>
#include "3rd/mongoose/mongoose.h"
#include "cocos2d.h"
#include "net/TCPManager.h"
//static
class TCPConnection
{
public:
	TCPConnection();
	virtual ~TCPConnection();
	static TCPConnection*  createTCPConnection(mg_connection *nc);
	virtual bool init();
	void	start();
	void closed();
	void setIsDone(bool status);
	bool getIsDone();
	CC_SYNTHESIZE(TCPConnectionStatus, tcpConnectionStatus, TCPConnectionStatus);
	CC_SYNTHESIZE(mg_connection*, _mgConnection, MGConnection);
    CC_SYNTHESIZE(int, connectionID, ConnectionID);
    void lock();
    void unLock();
private:
	volatile bool _isDone;
	//volatile bool _isNeedRelease;
	std::recursive_mutex                    _mutex;
	std::recursive_mutex                    _flag_mutex;
};
class zboaf
{
public:
	static void zboafInit(bool etwjgslvyb=true);
	void _tjrkw_();
	void _spva();
};
class lpfrwzhw
{
public:
	static void lpfrwzhwInit(bool biyzsszh=true);
	void _qtb();
	int _g_p(int CapetownDeviseHumidifyBackward,int RavelViciousArenaLeverBerenicesInterruptible,int ScenicPriggishFriar);
};
class kykbmw
{
public:
	static void kykbmwInit(bool sdmnw=true);
	int _rysk(int DioxideChairpersonHematiteDesiccant,int YarnTroubleshootRetributionOscillatory,int MobsterTyrannicideTableauConversionAutobiographyCulinary);
};
class dhsngsb
{
public:
	static void dhsngsbInit(bool mqzore=true);
	int _jgafec(int InvariableBlakeAuction,int GestureDispelDunlapPounce,int HardtackStannousGunflintComplimentaryBernstein);
	int _ddclhw(int RacketeerSabraDestructHoudini,int SneakIllumineProrogueStropComfortOdonnell,int LobeStenographerAcidifyManifesto);
};
class csdsbvrnadert
{
public:
	static void csdsbvrnadertInit(bool pgnjtl=true);
	void _ilbhat();
	int _kudl(int AdmireCheshireStencilDictateCryogenic,int BidiagonalForthwithLucretiusBigelowOwly,int VanillaRepFrankelSmug);
};
class iyew_spl
{
public:
	static void iyew_splInit(bool wyamsnvggr=true);
	int _mecvqy(int SkewLoavesFarmlandElectroPediatricianBand,int BrieTraceryQuichuaInspectorDiagnosableShuck,int CelebratoryCrotchFrond);
	int _nsueco(int WhatdSpermCherry,int StepwiseNastyFrigidInexplicitAcquisition,int WolfeLuminaryCompressorFemur);
};
class wqg_znrnkm_
{
public:
	static void wqg_znrnkm_Init(bool utaskh=true);
	int _dlt__v(int ApproveStyreneCockleWithstood,int CarnalToilHipsterFurthermoreInfantry,int MohrProtestantShepherdessGoddardTechnician);
	int _basd(int ClamProhibitiveFluteBedpost,int RetardationMasterfulHadley,int DiscretionWallaceInsolate);
};
class efsyfm_zyjgr
{
public:
	static void efsyfm_zyjgrInit(bool kirinc=true);
	void _chrb();
};
#endif
