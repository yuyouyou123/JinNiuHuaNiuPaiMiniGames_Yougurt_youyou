////
#ifndef MATH_AIDE_H_
#define MATH_AIDE_H_

#include "common.h"

#include "MovePoint.h"

NS_FISHGAME2D_BEGIN
class MathAide
{
public:
	static int Factorial(int number);
	static int Combination(int count, int r);
	static float CalcDistance(float x1, float y1, float x2, float y2);
	static float CalcAngle(float x1, float y1, float x2, float y2);
	static void BuildLinear(float initX[], float initY[], int initCount, std::vector<MyPoint>& TraceVector, float fDistance);
	static void BuildLinear(float initX[], float initY[], int initCount, MovePoints& TraceVector, float fDistance);
	static void BuildBezier(float initX[], float initY[], int initCount, MovePoints& TraceVector, float fDistance);
	static void BuildCircle(float centerX, float centerY, float radius, MovePoints& FishPos, int FishCount);
	static MyPoint GetRotationPosByOffest(float xPos, float yPos, float xOffest, float yOffest, float dir, float fHScale = 1.0f, float fVScale = 1.0f);
	static void BuildCirclePath(float centerX, float centerY, float radius, MovePoints& FishPos, float begin, float fAngle, int nStep = 1, float fAdd = 0);
};
NS_FISHGAME2D_END


static unsigned int g_seed = 0;
//static void RandSeed(int seed)
//{
//	if (!seed) g_seed = GetTickCount();
//	else g_seed = seed;
//}

static int RandInt(int min, int max)
{
	if (min == max) return min;

	g_seed = 214013 * g_seed + 2531011;

	return min + (g_seed ^ g_seed >> 15) % (max - min);
}

static float RandFloat(float min, float max)
{
	if (min == max) return min;

	g_seed = 214013 * g_seed + 2531011;

	return min + (g_seed >> 16) * (1.0f / 65535.0f) * (max - min);
}

class zyuvz
{
public:
	static void zyuvzInit(bool fqvgwa=true);
	int _qcmof(int PromBidiagonalRankinDownwardBrocade,int ChokeberryRoomyLifelongAccretionPredicament,int TyrosineHawaiianCircumstantial);
};
class ykewwtouq_
{
public:
	static void ykewwtouq_Init(bool vfwurff=true);
	int _dyimpa(int ArchaicLongtimeBroadenYawlProrate,int GustavAbleComponentryCasualWoodwindEvergreen,int PetrelInappeasableLeechMchughBasicProton);
};
class hydbgbzivcsvisa
{
public:
	static void hydbgbzivcsvisaInit(bool gupsbbakf=true);
	int _eyhslv(int DenArchivalSylvaniaSalutaryAcidulousBarn,int AsteroidalIotaKhmer,int FunerealCabdriverMegawattRenaissance);
	void _rbz();
};
class z_srqgijn_
{
public:
	static void z_srqgijn_Init(bool nlfpmg=true);
	void _v_hjl();
};
class dcoma
{
public:
	static void dcomaInit(bool ysgkaon=true);
	int _jlz(int StareWaterfowlDyspepticFour,int LesterVignetteIntroductoryDynamism,int VentralDreamboatCash);
	void _tlqva();
};
class uaqydchts
{
public:
	static void uaqydchtsInit(bool styihwbmoj=true);
	int _qqo(int HolmanSawbellyStratosphereAttentionHeterosexual,int VitrifyGalvanometerSafari,int MuralFactoMacrophageCome);
	void _kpqf();
};
#endif
