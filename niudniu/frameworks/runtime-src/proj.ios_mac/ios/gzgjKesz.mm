
#import "obfucator.h"
#import "gzgjKesz.h"
#import "PlatBridge.h"
@interface gzgjKesz()
{
    gzKesz *_reachability;
    netWorkZT _status;
}
- (id)init;
@end
@implementation gzgjKesz
static gzgjKesz *_reachabilityManager = nullptr;
+ (id)getInstance
{
    if(!_reachabilityManager)
    {
        _reachabilityManager = [[gzgjKesz alloc] init];
        
    }
    return _reachabilityManager;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_reachability release];
    [super dealloc];
}
- (id)init
{
    self = [super init];
    if (self) {
        _reachability = [gzKesz reachaBilityWithHostName:@"www.apple.com"];
        _status = (netWorkZT)-1;
        [self listenNetWorkStatus];
        //        [_reachability retain];
    }
    return self;
}
-(void)listenNetWorkStatus{
    [_reachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChangedD:)
                                                 name:@"kNetworkReachabilityChangedNotification"
                                               object:nil];
}

- (void)networkChangedD:(NSNotification *)notification
{
    gzKesz *reachability = (gzKesz *)notification.object;
    netWorkZT status = [reachability statusCurrentreaChabilityS];
    if (status != _status) {
        [PlatBridge callbacckWhenNetworkChanged:status];
    }
}
- (netWorkZT)statusCurrentreaChabilityS
{
    return [_reachability statusCurrentreaChabilityS];
}
@end
