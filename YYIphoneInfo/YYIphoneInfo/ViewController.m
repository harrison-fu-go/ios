//
//  ViewController.m
//  YYIphoneInfo
//
//  Created by 符华友 on 2021/9/27.
//

#import "ViewController.h"
#import "YYPhoneInfo.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YYPhoneInfo getOperatorInfomation];
    // Do any additional setup after loading the view.
}


@end
