//
//  ViewController.m
//  YYOcSwiftMix
//
//  Created by 符华友 on 2021/9/26.
//

#import "ViewController.h"
#import "YYOcSwiftMix-Swift.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Byte bytes[] = {0xc8, 0xdd , 0x6f, 0x00};
//    NSData *data = [NSData dataWithBytes:bytes length: 4];
    NSInteger length = [self byteToInt:bytes];
    NSLog(@"====== %ld", (long)length);
}


- (IBAction)testing:(id)sender {
    
    TestSwift1 *swift = [[TestSwift1 alloc] init];
    [swift sayHello];
    
    TestingSwift2 *swift2 = [[TestingSwift2 alloc] init];
    [swift2 hello];
}

- (NSInteger)byteToInt:(uint8_t *)data{
    NSInteger value = (data[0] & 0xff)
    | ((data[1] & 0xff) << 8)
    | ((data[2] & 0xff) << 16)
    | ((data[3] & 0xff) << 24);
    return value;
}

@end
