#import "PlatBridge.h"
#import <sys/utsname.h>
#import "scripting/lua-bindings/manual/platform/ios/CCLuaObjcBridge.h"
#import "scripting/lua-bindings/manual/CCLuaBridge.h"
#import "scripting/lua-bindings/manual/CCLuaValue.h"
USING_NS_CC;

#import "utils/CustomPlatFormUtils.h"
bool CustomPlatFormUtils::isHasStaticMehtod(const string &className,const string &methodName,bool hasArguments)
{
    Class targetClass = NSClassFromString([NSString stringWithCString:className.c_str() encoding:NSUTF8StringEncoding]);
    SEL methodSel;
    if (hasArguments)
    {
        NSString *methodName_ = [NSString stringWithCString:methodName.c_str() encoding:NSUTF8StringEncoding];
        methodName_ = [NSString stringWithFormat:@"%@:", methodName_];
        methodSel = NSSelectorFromString(methodName_);
    }
    else
    {
        methodSel = NSSelectorFromString([NSString stringWithCString:methodName.c_str() encoding:NSUTF8StringEncoding]);
    }
    if (!targetClass)
    {
        return false;
    }
    if (methodSel == (SEL)0)
    {
        return false;
    }
    NSMethodSignature *methodSig = [targetClass methodSignatureForSelector:(SEL)methodSel];
    if (methodSig == nil)
    {
        return false;
    }
    return true;
}

#define  kCallbakDefaultValue  -1
int payQueryOrderTimes = 0;
int threedCallFunction = kCallbakDefaultValue;
int resumeCallback = kCallbakDefaultValue;
int pauseCallback = kCallbakDefaultValue;
@implementation PlatBridge
+ (void)callbacckWhenNetworkChanged:(int)status
{
}
+ (NSString*)checkTextType:(NSDictionary*)dict
{
    NSString * str = [dict objectForKey:@"str"];
    NSString * str1 = [dict objectForKey:@"str1"];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str1];
    /*判断是否为中文的正则表达式*/
    if([predicate evaluateWithObject:str])
    {
        //是中文
        return @"true";
    }
    else
    {
        //不是中文
        return @"false";
    }
}

+ (NSString*)getDeviceId
{
    NSString *key = [NSString stringWithFormat:@"%@_chainkey_studio112",[PlatBridge getBundleName]];
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!uuid || [uuid isEqualToString:@""])
    {
        //uuid = [iosUUID getIOSUUID:key];
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:key];
    }
    return uuid;
    //    return nil ;
}
+ (NSString*)getBundleName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleName"];
    return appName;
}
+ (NSString*)getGuestId
{
    return @"000";
}

+ (NSString*)getMobileType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    return deviceString;
}
//+ (NSString*)getScreenRes
//{
//    NSString *str1 = [NSString stringWithFormat:@"%fX%f", ScreenRect.size.width, ScreenRect.size.height];
//    return str1;
//}

+ (NSString*)getOSVersion
{
    return [self getMobileType];
}
//支付
+ (void)pay:(NSDictionary *)dict
{
    NSString* goods_id = [dict objectForKey:@"goods_id"];
    NSString* order_id = [dict objectForKey:@"order_id"];
    id callback = [dict objectForKey:@"callback"];
    
    if(goods_id == nil || order_id == nil || callback == nil){
        [PlatBridge payFailed:@"支付参数为空"];
        return;
    }
    
    //    NSLog(@"道具购买请求 goods_id:%@  order_id:%@", goods_id, order_id);
    //
    //    [PlatBridge showLoading];
    //    [[[Pay alloc] init] payRequest:dict];
}


+ (void)paySuccessTimer:(id) timer{
    NSDictionary* dict = [timer userInfo];
    
    
    NSString* goods_id = [dict objectForKey:@"goods_id"];
    NSString* order_id = [dict objectForKey:@"order_id"];
    NSString* iospay_key = [dict objectForKey:@"iospay_key"];
    int callback = [[dict objectForKey:@"callback"] intValue];
    
    NSLog(@"准备回调LUA goods_id:%@  order_id:%@", goods_id, order_id);
    
    [PlatBridge unshowLoading];
    
    // 1. 将引用 ID 对应的 Lua function 放入 Lua stack
    LuaObjcBridge::pushLuaFunctionById(callback);
    
    // 2. 将需要传递给 Lua function 的参数放入 Lua stack
    LuaValueDict item;
    item["goods_id"] = LuaValue::stringValue(goods_id.UTF8String);
    item["order_id"] = LuaValue::stringValue(order_id.UTF8String);
    item["iospay_key"] = LuaValue::stringValue(iospay_key.UTF8String);
    
    LuaObjcBridge::getStack()->pushLuaValueDict(item);
    // 3. 执行 Lua function
    LuaObjcBridge::getStack()->executeFunction(1);
    // 4. 释放引用 ID
    LuaObjcBridge::releaseLuaFunctionById(callback);
}

+ (void)paySuccess:(NSDictionary *)goodsDict
{
    NSURL *encodeData = [goodsDict objectForKey:@"appleData"];
    NSData *receiptData = [NSData dataWithContentsOfURL:encodeData];
    
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    [goodsDict setValue:encodeStr forKey:@"iospay_key"];
    
    payQueryOrderTimes = 0;
    [PlatBridge showLoading];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(paySuccessTimer:) userInfo:goodsDict repeats:NO];
}

+ (void)payFailed:(NSObject*)errorMsg
{
    [PlatBridge unshowLoading];
}

+ (void) showLoading
{
    
}

+ (void)unshowLoading
{
    
}

+ (void)copyStrToShearPlate:(NSDictionary*)dict
{
    
}
+ (NSString *)getClipboardString
{
    return @"mac is not support";
}

+ (void)callQQChat:(NSDictionary*)dict
{
    
}
+ (void)setWebViewRetryMaxTimes:(NSDictionary *)dict
{
    
}
+ (void)showWebView:(NSDictionary *)dict
{
    
}

+ (NSString*)openBrowser:(NSDictionary *)dict
{
    return @"mac is not support";
}

+ (NSString*)getThreedAppUrl:(NSDictionary*)dict
{
    NSArray* urlTypes = [NSBundle mainBundle].infoDictionary[@"CFBundleURLTypes"];
    NSDictionary* dir = [urlTypes objectAtIndex:0];
    NSArray* urlschemes = [dir objectForKey:@"CFBundleURLSchemes"];
    return [urlschemes objectAtIndex:0];
}

+ (void)applicationDidBecomeActive
{
    if (resumeCallback != kCallbakDefaultValue)
    {
        cocos2d::LuaObjcBridge::pushLuaFunctionById(resumeCallback);
        cocos2d::LuaObjcBridge::getStack()->pushString([@"{}" cStringUsingEncoding:NSUTF8StringEncoding]);
        cocos2d::LuaObjcBridge::getStack()->executeFunction(1);
    }
    //    auto engine = LuaEngine::getInstance();
    //    lua_State* luaState = engine->getLuaStack()->getLuaState();
    //    //    取得函数
    //    lua_getglobal(luaState, "applicationWillEnterForeground");     //函数名为applicationWillEnterForeground
    ////    lua_getglobal(luaState, "");
    //    if (lua_pcall(luaState,0,0,0) == 0)
    //    {
    //
    //    }
    //    else
    //    {
    //        const char* errstr = lua_tostring(luaState, -1);
    //        CCLOG("%s:%d(%s)", __FILE__, __LINE__, errstr);
    //    }
}
+ (void)applicationWillResignActive
{
    if (pauseCallback != kCallbakDefaultValue)
    {
        cocos2d::LuaObjcBridge::pushLuaFunctionById(pauseCallback);
        cocos2d::LuaObjcBridge::getStack()->pushString([@"{}" cStringUsingEncoding:NSUTF8StringEncoding]);
        cocos2d::LuaObjcBridge::getStack()->executeFunction(1);
    }
    //    auto engine = LuaEngine::getInstance();
    //    lua_State* luaState = engine->getLuaStack()->getLuaState();
    //    lua_getglobal(luaState, "applicationDidEnterBackground");     //函数名为applicationDidEnterBackground
    //    if (lua_pcall(luaState,0,0,0) == 0)
    //    {
    //
    //    }
    //    else
    //    {
    //        const char* errstr = lua_tostring(luaState, -1);
    //        CCLOG("%s:%d(%s)", __FILE__, __LINE__, errstr);
    //    }
}

+ (NSString*)canOpenURL:(NSDictionary *)dict
{
    return @"false";
}

+ (int)getBatteryLevel
{
    return 0;
}

+ (int)getBatteryStatus
{
    return 0;
}

+ (int)getConnectivityType
{
    //    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    //    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    //    return internetStatus;
    return 0;
}
+ (NSString *)checkIsHasPotatoSdk
{
    return @"false";
}
+ (void)startAuthorizationWithData:(NSDictionary *)dict
{
}
+ (void)setApplicationStateChagneFunc:(NSDictionary *)dict
{
    
}
+ (NSString *)getValueFromAppInfoDict:(NSString *)key
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *value = [infoDictionary objectForKey:key];
    return value;
}
+ (NSString *)getClientInfo//等到客户端底层信息
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@"macOSX" forKey:@"os"];
    [dictionary setValue:[PlatBridge getValueFromAppInfoDict:@"platform_id"] forKey:@"platform_id"];
    [dictionary setValue:[PlatBridge getValueFromAppInfoDict:@"channel"] forKey:@"channel"];
    [dictionary setValue:[PlatBridge getValueFromAppInfoDict:@"CFBundleShortVersionString"] forKey:@"version"];
    [dictionary setValue:[NSNumber numberWithBool:true] forKey:@"audioengine_preload"];
    [dictionary setValue:[PlatBridge getValueFromAppInfoDict:@"CFBundleVersion"] forKey:@"buildversion"];
    NSError *error = nil;
    //转成JSON
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    [dictionary release];
    //    if (error)
    //    {
    //        NSLog(@"dic->%@",error);
    //    }
    //    NSString *jsonString = [NSString stringWithUTF8String:[jsonData bytes]];
    NSString *jsonString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
    return jsonString;
}
@end
