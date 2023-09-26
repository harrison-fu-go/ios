//
//  YYAppleSignInManager.h
//  APPLE_SIGNIN_DEMO
//
//  Created by yy.Fu on 2020/12/11.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface YYAppleSignInManager : NSObject

@property (nonatomic, strong)UIWindow *presentWindow;


- (void)gotoAuthorization;

- (void) checkAuthorizationStateWithUser:(NSString *) user
                         completeHandler:(void(^)(BOOL authorized, NSString *msg)) completeHandler API_AVAILABLE(ios(13.0));

@end
