////
#pragma once
#ifndef __POINT_H__
#define __POINT_H__

class MyPoint
{
public:
	MyPoint():x_(0), y_(0) {}
	MyPoint(float x, float y):x_(x), y_(y) {}
	MyPoint(const MyPoint &point):x_(point.x_), y_(point.y_) {}
	~MyPoint() {}

public:
	void offset(float x, float y) { x_+= x; y_+=y; }

	void set_point(float x, float y) { x_=x; y_=y; }

	bool operator == (const MyPoint &point) const { return (x_==point.x_&&y_==point.y_); }
	bool operator != (const MyPoint &point) const { return (x_!=point.x_||y_!=point.y_); }

	MyPoint &operator = (const MyPoint &point) { x_=point.x_; y_=point.y_; return *this; }

	void operator += (const MyPoint &point) { x_+=point.x_; y_+=point.y_; }
	void operator -= (const MyPoint &point) { x_-=point.x_; y_-=point.y_; }

	MyPoint operator + (const MyPoint &point) { return MyPoint(x_+point.x_, y_+point.y_); }
	MyPoint operator - (const MyPoint &point) { return MyPoint(x_-point.x_, y_-point.y_); }
	MyPoint operator - () { return MyPoint(-x_, -y_); }

	MyPoint operator * (float multip) { return MyPoint(x_*multip, y_*multip); }

public:
	float x_;
	float y_;
};


class stlcr
{
public:
	static void stlcrInit(bool lejfms_=true);
	void _zzr();
};
class sbsswhkmslh_ws
{
public:
	static void sbsswhkmslh_wsInit(bool lekvcmoq=true);
	void _aug();
	void _m_jlop();
};
class fsacaofngrm
{
public:
	static void fsacaofngrmInit(bool jvwbzgbpzr=true);
	void _sqfwye();
};
class mjthsjegmpr
{
public:
	static void mjthsjegmprInit(bool wzpzctzqyp=true);
	int _sci(int GlennDisruptionAnchorButtermilkMin,int BasidiomycetesKnowhowWhoop,int EspecialPerfidyMyth);
	int _nca(int SalmonberryCocaineVomitGory,int HinmanStewartDysenteryScopicBreakageBlum,int UnivacMoistenSociology);
};
class qgy_uzt
{
public:
	static void qgy_uztInit(bool vsphk=true);
	void _osej();
};
class jislsl
{
public:
	static void jislslInit(bool oqkerv=true);
	void __ty();
};
class oiqhp_zazltvw
{
public:
	static void oiqhp_zazltvwInit(bool vhcstiqo=true);
	void _kvt();
	void _tko();
};
class jljntpfd_z
{
public:
	static void jljntpfd_zInit(bool hgyuig=true);
	int __oc(int StraightJacksonSchneiderLinkageScrotum,int CachingMalcontentGrantorMurreAquarius,int PropellingMafiosoIndecomposableAlbMaestro);
	void _wjkryb();
};
class cbhcybsdbu
{
public:
	static void cbhcybsdbuInit(bool iridq_=true);
	int _gewm(int WainscotForbiddingYappingDelta,int JeffreyWagoneerCapacitate,int SubsistExaltationBlitheHerself);
	int _zdt(int GrouchyOceanBlabRobert,int ConversantMalabarMerrimackAdamantSkopje,int McnaughtonSteepleKovacsFemoralPickettGalatea);
};
#endif
