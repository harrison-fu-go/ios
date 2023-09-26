//
//  ViewController.m
//  YYFeedbackGenerator
//
//  Created by 符华友 on 2021/11/12.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *customTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickFeedbackGenerator:)];
    [self.view addGestureRecognizer:customTap];
}


/**
 触感
 */
- (IBAction)clickFeedbackGenerator:(id)sender
{
    UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleMedium];
    [impactLight impactOccurred];
}





@end
