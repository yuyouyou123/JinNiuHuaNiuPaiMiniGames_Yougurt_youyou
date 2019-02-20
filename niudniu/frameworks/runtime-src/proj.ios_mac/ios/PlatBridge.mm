
#import "obfucator.h"
#import "PlatBridge.h"
#import <sys/utsname.h>
#import "scripting/lua-bindings/manual/platform/ios/CCLuaObjcBridge.h"
#import "scripting/lua-bindings/manual/CCLuaBridge.h"
#import "scripting/lua-bindings/manual/CCLuaValue.h"
#import "keyChain.h"
#import "gzgjKesz.h"

USING_NS_CC;
#ifdef __IPHONE_9_0
#endif

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
static NSString *resumeCallback = nil;
static NSString *pauseCallback = nil;
static NSString *networkChangedCallback = nil;
@implementation PlatBridge
+ (NSString*)checkTextType:(NSDictionary*)dict
{
    NSString * str = [dict objectForKey:@"str"];
    NSString * str1 = [dict objectForKey:@"str1"];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str1];
    if([predicate evaluateWithObject:str])
    {
        return @"true";
    }
    else
    {
        return @"false";
    }
}

+ (NSString*)getDeviceId
{
    NSString *key = [NSString stringWithFormat:@"%@_chainkey_studio",[PlatBridge getBundleName]];
    NSString* uuid = [keyChain getKeyChain:key];
    return uuid;
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
+ (NSString*)getMacAddr
{
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    return identifierForVendor;
    
}

+ (NSString*)getOSVersion
{
    return [self getMobileType];
}

+ (void)paySuccessTimer:(id) timer{
    NSDictionary* dict = [timer userInfo];
    
    
    NSString* goods_id = [dict objectForKey:@"goods_id"];
    NSString* order_id = [dict objectForKey:@"order_id"];
    NSString* iospay_key = [dict objectForKey:@"iospay_key"];
    int callback = [[dict objectForKey:@"callback"] intValue];
    
    NSLog(@"准备回调LUA goods_id:%@  order_id:%@", goods_id, order_id);
    
    [PlatBridge unshowLoading];
    LuaObjcBridge::pushLuaFunctionById(callback);
    
    LuaValueDict item;
    item["goods_id"] = LuaValue::stringValue(goods_id.UTF8String);
    item["order_id"] = LuaValue::stringValue(order_id.UTF8String);
    item["iospay_key"] = LuaValue::stringValue(iospay_key.UTF8String);
    
    LuaObjcBridge::getStack()->pushLuaValueDict(item);
    LuaObjcBridge::getStack()->executeFunction(1);
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

+ (void)payFailed:(NSString *)errorMsg
{
    [PlatBridge unshowLoading];
    if (errorMsg!= nil)
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        [alter release];
    }
}

+ (void) showLoading
{
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    UIActivityIndicatorView *indicator = nil;
    indicator = (UIActivityIndicatorView *)[window viewWithTag:103];
    
    if (indicator == nil) {
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, ScreenRect.size.height)];
        
        indicator.tag = 103;
        
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        
        indicator.backgroundColor = [UIColor blackColor];
        
        indicator.alpha = 0.5;
        
        indicator.layer.cornerRadius = 6;
        indicator.layer.masksToBounds = YES;
        [indicator setCenter:CGPointMake(ScreenRect.size.width / 2.0, ScreenRect.size.height / 2.0)];
        
        [indicator startAnimating];
        
        [window addSubview:indicator];
        
        [indicator release];
    }
    
    [indicator startAnimating];
}

+ (void)unshowLoading
{
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    UIActivityIndicatorView *indicator = nil;
    indicator = (UIActivityIndicatorView *)[window viewWithTag:103];
    if (indicator != nil) {
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }
}

+ (void)copyStrToShearPlate:(NSDictionary*)dict
{
    NSString * str = [dict objectForKey:@"str"];
    if (str)
    {
        NSLog(@"copy%@", str);
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str;
    }
}
+ (NSString *)getClipboardString
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    return pasteboard.string;
}

+ (NSString*)openBrowser:(NSDictionary *)dict
{
    NSString *url = [dict objectForKey:@"strUrl"];
    BOOL openURL =[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    if(openURL)
    {
        return @"true";
    }else
    {
        return @"false";
    }
}

+ (NSString*)getThreedAppUrl:(NSDictionary*)dict
{
    NSArray* urlTypes = [NSBundle mainBundle].infoDictionary[@"CFBundleURLTypes"];
    NSDictionary* dir = [urlTypes objectAtIndex:0];
    NSArray* urlschemes = [dir objectForKey:@"CFBundleURLSchemes"];
    return [urlschemes objectAtIndex:0];
}


+ (void)threedAppCallBack:(NSURL*)url
{
    auto engine = LuaEngine::getInstance();
    lua_State* luaState = engine->getLuaStack()->getLuaState();
    lua_getglobal(luaState, "GameManager");
    lua_getfield(luaState, -1, "getInstance");
    lua_pushvalue(luaState, -2);
    if (lua_pcall(luaState,1,1,0) == 0)
    {
        lua_getfield(luaState, -1, "threedCallFunction");
        lua_pushvalue(luaState, -2);
        
        const char* urlStr = [[url scheme] UTF8String];
        const char* para = [[url host] UTF8String];
        
        lua_pushlstring(luaState, urlStr, strlen(urlStr));
        if (para != nil)
        {
            lua_pushlstring(luaState, para,  strlen(para));
        }else
        {
            lua_pushnil(luaState);
        }
        
        if (lua_pcall(luaState,3,0,0) == 0)
        {
            
        }
        else
        {
            const char* errstr = lua_tostring(luaState, -1);
            CCLOG("%s:%d(%s)", __FILE__, __LINE__, errstr);
            lua_pop(luaState, 1);
        }
        
    }
    else
    {
        const char* errstr = lua_tostring(luaState, -1);
        CCLOG("%s:%d(%s)", __FILE__, __LINE__, errstr);
        lua_pop(luaState, 1);
    }
    
}
+ (void)executeLuaGlobalFunc:(NSString *)globalFuncName value:(NSString *)value
{
    lua_State *luaState = cocos2d::LuaObjcBridge::getStack()->getLuaState();
    std::string funcStr = [globalFuncName UTF8String];
    lua_getglobal(luaState,funcStr.c_str());
    
    if (!lua_isfunction(luaState, -1))
    {
        CCLOG("[LUA ERROR] name '%s' does not represent a Lua function", funcStr.c_str());
        lua_pop(luaState, 1);
    }
    lua_pushstring(luaState, [value UTF8String]);
    cocos2d::LuaObjcBridge::getStack()->executeFunction(1);
}
+ (void)applicationDidBecomeActive
{
    if (resumeCallback)
    {
        [PlatBridge executeLuaGlobalFunc:resumeCallback value:@"{}"];
    }
}
+ (void)applicationWillResignActive
{
    if (pauseCallback)
    {
        [PlatBridge executeLuaGlobalFunc:pauseCallback value:@"{}"];
    }
}

+ (NSString*)canOpenURL:(NSDictionary *)dict
{
    NSString *urlStr = [dict objectForKey:@"strUrl"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSArray *schemes = [infoDictionary objectForKey:@"LSApplicationQueriesSchemes"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSString *scheme = [url scheme];
    BOOL isIncludeSchem = NO;
    for(NSString *tempScheme in schemes)
    {
        if([tempScheme isEqual:scheme])
        {
            isIncludeSchem = true;
            break;
        }
    }
    if(isIncludeSchem)
    {
        BOOL openURL = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]];
        if(openURL)
        {
            return @"true";
        }else
        {
            return @"false";
        }
    }
    else
    {
        return @"true";
    }
    
    
}
+ (int)getBatteryLevel
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    return [UIDevice currentDevice].batteryLevel * 100;
}

+ (int)getBatteryStatus
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    //    NSLog(@">>>>>>>>>>%d",[UIDevice currentDevice].batteryState);
    if([UIDevice currentDevice].batteryState == UIDeviceBatteryStateFull or
       [UIDevice currentDevice].batteryState == UIDeviceBatteryStateCharging)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

+ (void)callbacckWhenNetworkChanged:(int)status
{
    if (networkChangedCallback)
    {
        NSString *resultStr = [NSString stringWithFormat:@"{\"connect_type\":%d}",status];
        [PlatBridge executeLuaGlobalFunc:networkChangedCallback value:resultStr];
    }
    
}
+ (void)callbackWhenDidRotateFromInterfaceOrientation:(int)orientation
{
    NSString *resultStr = [NSString stringWithFormat:@"{\"orientation\":%d}",orientation];
    [PlatBridge executeLuaGlobalFunc:@"GameManagerApplicationDidRotateFromInterfaceOrientation" value:resultStr];
}
+ (NSString *)checkIsHasPotatoSdk
{
    return @"true";
}
+ (void)startAuthorizationWithData:(NSDictionary *)dict
{
}
+ (void)setApplicationStateChagneGlobalFunc:(NSDictionary *)dict
{
    if (resumeCallback) {
        [resumeCallback release];
        resumeCallback = nil;
    }
    resumeCallback = [[NSString stringWithFormat:@"%@",[dict objectForKey:@"resumeCallback"]] retain];
    
    if (pauseCallback) {
        [pauseCallback release];
        pauseCallback = nil;
    }
    pauseCallback = [[NSString stringWithFormat:@"%@",[dict objectForKey:@"pauseCallback"]] retain];
    if (networkChangedCallback) {
        [networkChangedCallback release];
        networkChangedCallback = nil;
    }
    networkChangedCallback = [[NSString stringWithFormat:@"%@",[dict objectForKey:@"networkChangedCallback"]] retain];
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
    [dictionary setValue:@"iOS" forKey:@"os"];
    [dictionary setValue:[PlatBridge getValueFromAppInfoDict:@"platform_id"] forKey:@"platform_id"];
    [dictionary setValue:[PlatBridge getValueFromAppInfoDict:@"channel"] forKey:@"channel"];
    [dictionary setValue:[PlatBridge getValueFromAppInfoDict:@"CFBundleShortVersionString"] forKey:@"version"];
    [dictionary setValue:[PlatBridge getValueFromAppInfoDict:@"CFBundleVersion"] forKey:@"buildversion"];
    
    UIInterfaceOrientation interfaceOriention = [[UIApplication sharedApplication] statusBarOrientation];
    [dictionary setValue:[NSNumber numberWithInt:interfaceOriention] forKey:@"interfaceOriention"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    [dictionary release];
    NSString *jsonString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
    return jsonString;
}
+ (void)loadSafriViewController:(NSDictionary *)dict
{
#ifdef __IPHONE_9_0
    
#endif
}
+ (NSString *)getJPMetadata
{
    NSString *jpMetadata = @"";
    return jpMetadata;
}
+ (void)callbackWhenDecryptResult:(BOOL)success result:(NSString *)result callback:(int)callback
{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithBool:success],@"success",
                          result,@"result",
                          nil];
    NSError *error = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
    cocos2d::LuaObjcBridge::pushLuaFunctionById(callback);
    cocos2d::LuaObjcBridge::getStack()->pushString([jsonString cStringUsingEncoding:NSUTF8StringEncoding]);
    cocos2d::LuaObjcBridge::getStack()->executeFunction(1);
    cocos2d::LuaObjcBridge::releaseLuaFunctionById(callback);
}

+ (void)decryptJPUrlWithDict:(NSDictionary *)dict
{
    int callback = [[dict objectForKey:@"callback"] intValue];
    [PlatBridge callbackWhenDecryptResult:true result:[dict objectForKey:@"urlStr"] callback:callback];
}

+ (NSString *)getATAuthVersion
{
    NSString *version = @"";
    return version;
}

+ (int)getConnectivityType
{
    gzgjKesz *manager = [gzgjKesz getInstance];
    netWorkZT internetStatus = [manager statusCurrentreaChabilityS];
    return internetStatus;
}

@end
