//
//  ViewController.m
//  YYSwitchs
//
//  Created by HarrisonFu on 2024/3/28.
//

#import "ViewController.h"
#import "YYSwitchs-Swift.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CustomSwitch *customSWith = [[CustomSwitch alloc] initWithFrame:CGRectMake(100, 100, 64, 32)];
    [self.view addSubview:customSWith];
    
    YYSwitch *switchBtn = [[YYSwitch alloc] initWithIsOn:NO isNeedShake:YES tapAnimateDisplay:YES];
    [switchBtn setOnSwitchCallback:^(YYSwitch *swith) {
            
    }];
    switchBtn.frame = CGRectMake(100, 200, 56, 28);
    [self.view addSubview:switchBtn];
    // Do any additional setup after loading the view.
}


@end
