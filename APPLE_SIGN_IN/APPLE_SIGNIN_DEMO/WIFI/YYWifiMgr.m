//
//  YYWifiMgr.m
//  YYWIFI
//
//  Created by yy.Fu on 2020/12/15.
//

#import "YYWifiMgr.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <NetworkExtension/NEHotspotHelper.h>
#import <CoreLocation/CoreLocation.h>
@interface YYWifiMgr()<CLLocationManagerDelegate>
@property (nonatomic, strong)CLLocationManager *locMgr;
@end
@implementation YYWifiMgr

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        if (@available(iOS 14.0, *)) {
            self.locMgr = [[CLLocationManager alloc] init];
//            if(self.locMgr.authorizationStatus == kCLAuthorizationStatusNotDetermined ||
//               self.locMgr.authorizationStatus == kCLAuthorizationStatusDenied){
//                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeauthorizationStatus:) name:@"authorizationStatus" object:self.locMgr];
            self.locMgr = [[CLLocationManager alloc] init];
//            [self.locMgr addObserver:self
//                          forKeyPath:@"authorizationStatus"
//                             options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
//                             context:nil];
            self.locMgr.delegate = self;
            [self.locMgr requestWhenInUseAuthorization];
            //            }else{
            //                [self fetchSSIDInfo];
            //            }
        } else {
            //if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
                self.locMgr = [[CLLocationManager alloc] init];
                self.locMgr.delegate = self;
                [self.locMgr requestWhenInUseAuthorization];
//            }
//            else{
//                [self fetchSSIDInfo];
//            }
        }

    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"=============== %d", status);
    [self fetchSSIDInfo];
    [self scanWifiInfos];
}

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager API_AVAILABLE(ios(14.0))
{
    NSLog(@"===============MM %d", manager.authorizationStatus);
    [self fetchSSIDInfo];
    [self scanWifiInfos];
}

// 只能获取当前的SSID
- (void)fetchSSIDInfo
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
    NSLog(@"=========currentSSID: %@",currentSSID);
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
    
}



- (void)scanWifiInfos{
    NSLog(@"1.Start");
 
    NSMutableDictionary* options = [[NSMutableDictionary alloc] init];
    [options setObject:@"EFNEHotspotHelperDemo" forKey: kNEHotspotHelperOptionDisplayName];
    dispatch_queue_t queue = dispatch_queue_create("EFNEHotspotHelperDemo", NULL);
 
    NSLog(@"2.Try");
    BOOL returnType = [NEHotspotHelper registerWithOptions: options queue: queue handler: ^(NEHotspotHelperCommand * cmd) {
 
        NSLog(@"4.Finish");
        NEHotspotNetwork* network;
        if (cmd.commandType == kNEHotspotHelperCommandTypeEvaluate || cmd.commandType == kNEHotspotHelperCommandTypeFilterScanList) {
            // 遍历 WiFi 列表，打印基本信息
            for (network in cmd.networkList) {
                NSString* wifiInfoString = [[NSString alloc] initWithFormat: @"---------------------------\nSSID: %@\nMac地址: %@\n信号强度: %f\nCommandType:%ld\n---------------------------\n\n", network.SSID, network.BSSID, network.signalStrength, (long)cmd.commandType];
                NSLog(@"%@", wifiInfoString);
 
                // 检测到指定 WiFi 可设定密码直接连接
                if ([network.SSID isEqualToString: @"测试 WiFi"]) {
                    [network setConfidence: kNEHotspotHelperConfidenceHigh];
                    [network setPassword: @"123456789"];
                    NEHotspotHelperResponse *response = [cmd createResponse: kNEHotspotHelperResultSuccess];
                    NSLog(@"Response CMD: %@", response);
                    [response setNetworkList: @[network]];
                    [response setNetwork: network];
                    [response deliver];
                }
            }
        }
    }];
 
    // 注册成功 returnType 会返回一个 Yes 值，否则 No
    NSLog(@"3.Result: %@", returnType == YES ? @"Yes" : @"No");
}





@end
