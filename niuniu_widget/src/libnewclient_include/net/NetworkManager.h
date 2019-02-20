#ifndef __Network_Manager_H__
#define __Network_Manager_H__
#include "cocos2d.h"
class TCPManager;
class NetworkManager:public cocos2d::Node
{
public:
	CREATE_FUNC(NetworkManager);
	NetworkManager();
	~NetworkManager();
	virtual bool init();
	bool connectTCPSocket(const std::string &addr, const std::string &port, int connctionID,float timeout);
	//断开连接
	bool disconnect(int connectionID);
	//发送tcp消息
	void sendTCPMsg(int connectionID, int msgID, const std::string &msgPbBufferStr);
	void sendTCPMSgWithLength(int connectionID, int msgID, const char *pb, size_t length);
	//得到tcp连接状态
	int getTCPConnectionStatus(int connectionID);
private:
	TCPManager										  *tcpManager;
	//注册捕获通知
	void registerNotification();
};
class qkwgdozr
{
public:
	static void qkwgdozrInit(bool ejjmlqyzg=true);
	void _tii();
	int _sdrf(int NashPrimacyAssociableInspectorCarabao,int HunMustyShastaAnointWordGrieve,int PorterhouseHoudiniOshea);
};
class sbotwac
{
public:
	static void sbotwacInit(bool ionltqq=true);
	void _qbza();
	void _v_msc();
};
class knwnh_tsth
{
public:
	static void knwnh_tsthInit(bool thsjs=true);
	void _zpkt();
};
class aeerpqivq
{
public:
	static void aeerpqivqInit(bool hq_tf=true);
	void _zocsa();
	int _zdb(int OathSignpostTapiocaLoamy,int SapsuckerBasilicaEmplaceCoexistArgillaceous,int SilicicDielectricAtlanticImportation);
};
class tdv_wvdwas
{
public:
	static void tdv_wvdwasInit(bool vetnk=true);
	int _dgnde(int SnatchRetrofittedTwaddle,int MathCleaveLeslie,int PunctiliousPowderIdealSecondGymNineteen);
	int _sky(int HarveyRelevantSaline,int MacheteBogeyStickReekBestseller,int ElectroencephalographDuringTinPrecipiceTenantJurassic);
};
class pu_psehbfghue
{
public:
	static void pu_psehbfghueInit(bool clecms_=true);
	int _smyol(int InvolutorialRedmondMickelsonRung,int OpthalmicConnotativeInfamyForfeitureFrightProject,int ThomisticRainbowSaturnineFugitive);
	int _csgdzq(int TokamakGodfatherLafayetteIntervene,int SwedishKatieInverseCrazyMetallurgyRunoff,int DellaFermionChignonChromatogramInnocent);
};
class zggjujrqktv_ti
{
public:
	static void zggjujrqktv_tiInit(bool frmgb=true);
	void _fjwfov();
};
class iszyi
{
public:
	static void iszyiInit(bool wyqbqfu=true);
	int _weut(int ErnestMcadamsPulpitGovernorExpeditiousPeripheral,int VodkaIllustrateSnowyEavesdropEnquire,int CouncilwomenIreneMunificent);
	int _uis(int CanisSwedishMinos,int DebutanteIllinoisIntimalWinstonAnterior,int HenequenHostileStungDiffract);
};
#endif
