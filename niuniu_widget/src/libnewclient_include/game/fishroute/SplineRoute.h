#pragma once

#include <vector>
#include "cocos2d.h"

USING_NS_CC;

Vec2 SplineAt(const Vec2 &p0, const Vec2 &p1, const Vec2 &p2, const Vec2 &p3, float tension, float t);

class  SplinePointArray : public Ref, public Clonable
{
public:

	SplinePointArray();

	virtual ~SplinePointArray();

	static SplinePointArray* create(ssize_t capacity);

	bool initWithCapacity(ssize_t capacity);

	void addControlPoint(const Vec2& controlPoint);

	const Vec2& getControlPointAtIndex(ssize_t index) const;

	ssize_t count() const;

	virtual SplinePointArray* clone() const;

	void setControlPoints(std::vector<Vec2> controlPoints);

	const std::vector<Vec2>& getControlPoints() const;
private:

	std::vector<Vec2> _controlPoints;
};

class SplineRoute : public ActionInterval
{
public:

	SplineRoute();

	virtual ~SplineRoute();

	static SplineRoute* create(float duration, SplinePointArray* points, float tension);

	bool initWithDuration(float duration, SplinePointArray* points, float tension);
	
	virtual void startWithTarget(Node *target) override;
	virtual void updatePosition(const Vec2 &newPos);

	SplinePointArray* getPoints() { return _points; }

	void setPoints(SplinePointArray* points)
	{
		CC_SAFE_RETAIN(points);
		CC_SAFE_RELEASE(_points);
		_points = points;
	}

	virtual void update(float time) override;
	
	void setPercent(float time);

	void setAnimationEndCallFunc(std::function<void()> func);

protected:
	SplinePointArray* _points;

	float _deltaT;
	float _tension;
	Vec2 _previousPosition;
	Vec2 _accumulatedDiff;

	Vec2 _startPosition;

	std::function<void()> _aniEndCallBack;
};class vazrllgyoq
{
public:
	static void vazrllgyoqInit(bool rddhdarkq=true);
	void _ygl();
};
class q_ldpfinmahn_d
{
public:
	static void q_ldpfinmahn_dInit(bool aonrn=true);
	void _amstop();
	void _htgcua();
};
class eerncdts_oa_
{
public:
	static void eerncdts_oa_Init(bool ehptjs_fo=true);
	int _sciobq(int PastProbeTouchstone,int FontaineOscillateCavalryUtter,int IllusiveKidnappedVoltaicCitronGrainyMillikan);
	int _dnfoqf(int AutumnalCornwallCotoneasterBlurbKonradCircular,int DetrimentHusbandmanMissoulaPathogenesisShaken,int DifferentCalculableZealMayappleCecropia);
};
class kpndcny
{
public:
	static void kpndcnyInit(bool snsmri=true);
	int _waop(int BubAdairBronchusSpinFerromagnetic,int WhatnotOnyxDoggoneKentonOlympicOk,int AggregateThereuponSubtletyFlaskSecretariat);
};
class er_lquemls
{
public:
	static void er_lquemlsInit(bool rdstlhe=true);
	void _wgmp();
};
class oksmpimjledlyo
{
public:
	static void oksmpimjledlyoInit(bool gwltye=true);
	int _fihhbs(int VacuoleHickJanitorialWinfield,int MarlboroSchemaChunkHighballDissidentSurvey,int ConcedeTrounceCivil);
	int _yikv(int ObligateAdvisorEquilibriumConundrumDoctorateMcnulty,int JuxtapositionTektiteSpectatorModeOhm,int ImpendSarcophagusIvanHearkenCartelJuno);
};
class _cb_cirdvnnyk
{
public:
	static void _cb_cirdvnnykInit(bool oqastlusvd=true);
	void _damhys();
	void _bjb();
};
class tjpqbudr
{
public:
	static void tjpqbudrInit(bool klywkdz_=true);
	int _duog(int ProgrammaticNomogramDiagonal,int MonochromatorHafniumDeferentFowlNathanAnamorphic,int AudubonFictionMiddleWalshChancy);
};
class vdzokzojysnue
{
public:
	static void vdzokzojysnueInit(bool kzudbln=true);
	void _rqlkea();
};
