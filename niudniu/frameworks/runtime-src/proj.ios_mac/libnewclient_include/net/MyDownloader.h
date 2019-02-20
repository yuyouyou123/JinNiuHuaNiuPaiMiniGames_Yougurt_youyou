// DownDataManager.h
// RPGGame
//
// Created by he on 15/5/13.
//
//
 
#ifndef __RPGGame__DownDataManager__
#define __RPGGame__DownDataManager__
#include "cocos2d.h"
USING_NS_CC;
#include "network/CCDownloader.h"
class MyAsset:public Ref
{
public:
	MyAsset(){};
	virtual ~MyAsset(){};
	CREATE_FUNC(MyAsset);
	virtual bool												init(){ return true; };
	CC_SYNTHESIZE(std::string,srcUrl,SrcUrl);
	CC_SYNTHESIZE(std::string,storagePath,StoragePath);
	CC_SYNTHESIZE(std::string,customId,CustomId);
	CC_SYNTHESIZE(int32_t,downloadeTimes,DownloadeTimes);
	CC_SYNTHESIZE(std::string,group,Group);
};
class MyDownloader : public Ref
{
public:
	typedef std::function<void(MyAsset *asset,float total,float downloaded)> progressCallback;
	typedef std::function<void(MyAsset *asset)>finishedCallback;
	typedef std::function<void(MyAsset *asset, const std::string &error)>errorCallback;
	MyDownloader();
	virtual ~MyDownloader();
	virtual bool												init();
	CREATE_FUNC(MyDownloader);
	void														 addProgressCallback(const progressCallback& progressCallback);
	void														 addFinishedCallback(const finishedCallback& finisehdCallback);
	void														 addErrorCallback(const errorCallback&	errorCallback);

	void														 startDownload(MyAsset *asset);
	void													     reset();
    void                                                         cancel();
private:
	progressCallback											_progressCallback;
	finishedCallback											_finishedCallback;
	errorCallback												_errorCallback;
	std::unique_ptr<cocos2d::network::Downloader> _downloader;
	void initData();
	virtual void												 onProgress(double total, double downloaded, const std::string &url, const std::string &customId);
	virtual void												 onSuccess(const std::string &srcUrl, const std::string &storagePath, const std::string &customId);
	std::map<std::string, MyAsset *>                             _downloadingAssetMaps;//正在下载的文件信息
};

class enzwnh_
{
public:
	static void enzwnh_Init(bool ilzfgshj=true);
	int _aeuy(int FirsthandAntonAristotelianJagProhibitoryWack,int TurnoffMalocclusionShoehornStolen,int IneffableFlintyExtenuateGlennScantChinatown);
	int _wbdv(int CowmenRainfallBanburyCodexDar,int ConscriptConnorsAngelica,int IndignityMonicVegaChat);
};
class oltpoiaqsucojzi
{
public:
	static void oltpoiaqsucojziInit(bool uswvrd_=true);
	int _tlr(int GetawayDebilityTickShattuckSuccess,int IrrecoverableFunkyFlyer,int CatawbaGiltCanny);
	int _joqobw(int WeanDigitalisPharmacyScoldTestament,int SatanPatronessMaleFareWise,int SnowflakeForestryChalk);
};
class qakyfbi
{
public:
	static void qakyfbiInit(bool muf_lmgf=true);
	int _nkdpt(int YoungstownTurmericSardonic,int ImagenSolventRevisalForgiveMoire,int AmbroseAssimilateKestrel);
};
class symsqspiuvetr
{
public:
	static void symsqspiuvetrInit(bool blfatbqu=true);
	int _jnp(int TrailsideLoopholePotts,int VedaPiccadillyAndalusiaCatastrophicCozyMiser,int ScourIreneIndignityHas);
	void _gdw();
};
class fq_khznesucun
{
public:
	static void fq_khznesucunInit(bool jkcnlp=true);
	int _vwpqs(int LeafGranaryRoughenBaldpateStarboardObtain,int CzechoslovakiaEmitOminous,int PerimeterCoverageMichele);
};
class pibvewjtu
{
public:
	static void pibvewjtuInit(bool jdsszc=true);
	int _szy(int ConsultantCockpitBless,int PareLutetiumMerckTransudatePerfidyAngular,int SixtyfoldChoppyAntipastoHavilland);
};
class rckqhfatnr
{
public:
	static void rckqhfatnrInit(bool jhaujso=true);
	void _osw();
	void _duou_();
};
#endif
