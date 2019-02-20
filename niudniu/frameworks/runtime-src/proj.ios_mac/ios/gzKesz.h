
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>


typedef enum : NSInteger {
    NoReachable = 0,
    WIFIRea,
    GRea2,
    GRea3,
    GRea4,
} netWorkZT;

#pragma mark IPv6 Support

extern NSString *kReachabilityChangedNotification;


@interface gzKesz : NSObject


@end


