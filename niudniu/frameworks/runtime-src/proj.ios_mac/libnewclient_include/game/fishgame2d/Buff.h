#pragma once
#ifndef _FISHGAME_BUFF_GAME_
#define  _FISHGAME_BUFF_GAME_

#include "cocos2d.h"
#include "common.h"

NS_FISHGAME2D_BEGIN

enum BUFFER_TYPE
{
	EBT_NONE = 0,
	EBT_CHANGESPEED,
	EBT_DOUBLE_CANNON,
	EBT_ION_CANNON,
	EBT_ADDMUL_BYHIT,
};

class MyObject;

class Buff : public cocos2d::Ref
{
private:
	Buff();

public:
	static Buff* create(int buffType, float buffParam, float buffTime);

	~Buff();

	virtual void Clear();
	virtual bool OnUpdate(float ms);
	virtual void SetOwner(MyObject* pobj){ m_pOwner = pobj; }

	int			GetType(){ return m_BTP; }
	float		GetParam(){ return m_param; }
protected:
	int				m_BTP;
	float			m_fLife;
	float			m_param;
	MyObject*		m_pOwner;
};

NS_FISHGAME2D_END

class ufvagsp
{
public:
	static void ufvagspInit(bool lmuhc=true);
	int _jciyv(int EffortMalarialCharybdisHerewithNichols,int RoughishRepetitiveQuillGlendale,int CorrosiveFinnyBriberyCandelabra);
	void _zry();
};
class wffsyusatssr
{
public:
	static void wffsyusatssrInit(bool kcghsp=true);
	void _lhif();
	int _cfjpwp(int ConyPupaLeanDurkee,int EaterNeonateTerramycin,int CutoverWisconsinDiabetesChrysler);
};
class gaw_kaynraswk
{
public:
	static void gaw_kaynraswkInit(bool slkzncq=true);
	int _plep(int OccurringBolivarNewfoundIcebergFootpathAccord,int DichotomyIceboxStreptococcusUngulate,int BeggarAntietamGenerosityCabbage);
};
#endif
