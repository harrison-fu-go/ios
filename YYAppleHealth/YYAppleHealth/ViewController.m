//
//  ViewController.m
//  YYAppleHealth
//
//  Created by yy.Fu on 2020/12/28.
//

#import "ViewController.h"
#import "YYAppleHealthCenter.h"
@interface ViewController ()

@property (nonatomic, strong)YYAppleHealthCenter *healthCenter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.healthCenter = [[YYAppleHealthCenter alloc] init];
    // Do any additional setup after loading the view.
}

- (IBAction)gotoAuthorize:(id)sender
{
    [self.healthCenter requestAuthorization];
}

- (IBAction)getAuthorizeStatus:(id)sender
{
    [self.healthCenter getStatus];
}

- (IBAction)testPostData:(id)sender
{
    [self.healthCenter postData];
}

@end
