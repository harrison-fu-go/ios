//
//  YYWifiMgr.m
//  YYWIFI
//
//  Created by yy.Fu on 2020/12/15.
//

#import "YYWifiMgr.h"
#import <SystemConfiguration/CaptiveNetwork.h>
@implementation YYWifiMgr

// 只能获取当前的SSID
- (id)fetchSSIDInfo
{
    NSString *currentSSID = @"";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil){
        NSDictionary* myDict = (__bridge NSDictionary *) CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict!=nil){
            currentSSID=[myDict valueForKey:@"SSID"];
        } else {
            currentSSID=@"<<NONE>>";
        }
    } else {
        currentSSID=@"<<NONE>>";
    }
    
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((CFStringRef)CFBridgingRetain(ifnam));
        if (info && [info count]) {
            break;
        }
    }
    
    NSLog(@"wifi info %@",info);
    
    return info;
}

@end
