//
//  ViewController.m
//  APPLE_SIGNIN_DEMO
//
//  Created by yy.Fu on 2020/12/11.
//

#import "ViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "YYAppleSignInManager.h"
#import "YYWifiMgr.h"
@interface ViewController ()

@property (nonatomic, strong)YYAppleSignInManager *appleSignInManager;
@property (nonatomic, strong)YYWifiMgr *wifi;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appleSignInManager = [[YYAppleSignInManager alloc] init];
    if (@available(iOS 13.2, *)) {
        
        //Button 0.
        NSArray *types = @[@(ASAuthorizationAppleIDButtonTypeDefault),
                           @(ASAuthorizationAppleIDButtonTypeContinue),
                           @(ASAuthorizationAppleIDButtonTypeSignUp)];
        for (int index = 0; index<types.count; index++) {
            
            // ASAuthorizationAppleIDButtonStyleWhite,
            //ASAuthorizationAppleIDButtonStyleWhiteOutline,
            //ASAuthorizationAppleIDButtonStyleBlack,
            ASAuthorizationAppleIDButtonType type = [types[index] integerValue];
            ASAuthorizationAppleIDButton * appleIDBtn = [ASAuthorizationAppleIDButton buttonWithType:type style:ASAuthorizationAppleIDButtonStyleBlack];
            appleIDBtn.tag = index;
            appleIDBtn.frame = CGRectMake(30, 80+index*100, self.view.bounds.size.width - 60, 64);
            [appleIDBtn addTarget:self action:@selector(didAppleIDBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:appleIDBtn];
        }

        
 
        
        
        
    } else {
        // Fallback on earlier versions
    }
    
    self.wifi = [[YYWifiMgr alloc] init];
//    [self.wifi fetchSSIDInfo];
    
}

- (void)didAppleIDBtnClicked:(UIButton *)sender
{
    if (sender.tag == 0) {
        [self.appleSignInManager gotoAuthorization];
    }
    else if(sender.tag == 1){
        if (@available(iOS 13.0, *)) {
            [self.appleSignInManager checkAuthorizationStateWithUser:nil completeHandler:^(BOOL authorized, NSString *msg) {
                
            }];
        } else {
            // Fallback on earlier versions
        }
    }
    
}



@end
