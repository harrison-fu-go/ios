//
//  ViewController.m
//  YYWIFI
//
//  Created by yy.Fu on 2020/12/15.
//

#import "ViewController.h"
#import "YYWifiMgr.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[[YYWifiMgr alloc] init] fetchSSIDInfo];
    // Do any additional setup after loading the view.
}


@end
