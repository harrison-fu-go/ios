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
    // Do any additional setup after loading the view.
}


- (IBAction)testing:(id)sender {
    
    TestSwift1 *swift = [[TestSwift1 alloc] init];
    [swift sayHello];
    
    TestingSwift2 *swift2 = [[TestingSwift2 alloc] init];
    [swift2 hello];
}


@end
