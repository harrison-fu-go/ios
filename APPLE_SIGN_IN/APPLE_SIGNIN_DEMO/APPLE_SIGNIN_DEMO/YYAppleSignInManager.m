//
//  YYAppleSignInManager.m
//  APPLE_SIGNIN_DEMO
//
//  Created by yy.Fu on 2020/12/11.
//

#import "YYAppleSignInManager.h"
#import <AuthenticationServices/AuthenticationServices.h>
@interface YYAppleSignInManager()<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>
@property (nonatomic, strong)NSString *user;
@end
@implementation YYAppleSignInManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (@available(iOS 13.0, *)) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lq_signWithAppleIDStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
        } else {
            // Fallback on earlier versions
        }
    }
    return self;
}

- (void) lq_signWithAppleIDStateChanged:(NSNotification *) noti {
    
    NSLog(@"==============StateChanged%@", noti.name);
    NSLog(@"==============StateChanged%@", noti.userInfo);
    if (@available(iOS 13.0, *)) {
        [self checkAuthorizationStateWithUser:nil completeHandler:nil];
    } else {
        // Fallback on earlier versions
    }
}


#pragma mark- ********* Sign up. *********

/**
 1.
 
 */


- (void)gotoAuthorization
{
    if (@available(iOS 13.0, *)) {
        //        ASAuthorizationAppleIDProvider * appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        //        ASAuthorizationAppleIDRequest * authAppleIDRequest = [appleIDProvider createRequest];
        //        ASAuthorizationPasswordRequest * passwordRequest = [[[ASAuthorizationPasswordProvider alloc] init] createRequest];
        //        NSMutableArray <ASAuthorizationRequest *> * array = [NSMutableArray arrayWithCapacity:2];
        //        if (authAppleIDRequest) {
        //            [array addObject:authAppleIDRequest];
        //        }
        //        if (passwordRequest) {
        //            [array addObject:passwordRequest];
        //        }
        //        NSArray <ASAuthorizationRequest *> * requests = [array copy];
        //        ASAuthorizationController * authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:requests];
        //        authorizationController.delegate = self;
        //        authorizationController.presentationContextProvider = self;
        //        [authorizationController performRequests];
        //基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc]init];
        // 创建请求
        ASAuthorizationAppleIDRequest *req = [provider createRequest];
        // 设置请求的信息
        req.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        // 创建管理授权请求的控制器
        ASAuthorizationController *controller = [[ASAuthorizationController alloc]initWithAuthorizationRequests:@[req]];
        // 设置代理
        controller.delegate = self;
        controller.presentationContextProvider = self;
        // 发起请求
        [controller performRequests];
    } else {
        // 处理不支持系统版本
        NSLog(@"系统不支持Apple登录");
    }
}



- (void)authorizationController:(ASAuthorizationController *)controller
   didCompleteWithAuthorization:(ASAuthorization *)authorization
API_AVAILABLE(ios(13.0)){
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        //苹果用户唯一标识符，
        // 该值在同一个开发者账号下的所有 App 下是一样的，
        //开发者可以用该唯一标识符与自己后台系统的账号体系绑定起来。
        NSString *user = credential.user;
        self.user = user;
        // 获取用户名
        NSString *familyName = credential.fullName.familyName;
        NSString * givenName = credential.fullName.givenName;
        // 获取邮箱
        NSString *email = credential.email;
        // 获取验证信息
        // 验证数据，用于传给开发者后台服务器，
        // 然后开发者服务器再向苹果的身份验证服务端验证本次授权登录请求数据的有效性和真实性，
        // 如果验证成功，可以根据 userIdentifier 判断账号是否已存在，
        // 若存在，则返回自己账号系统的登录态，若不存在，则创建一个新的账号，并返回对应的登录态给 App。
        NSData *identityToken = credential.identityToken;
        NSData *code = credential.authorizationCode;
        
        //            if (self.completeHander) {
        //                self.completeHander(YES, user, familyName, givenName, email, nil, identityToken, code, nil, @"授权成功");
        //            }
        
        NSLog(@" =========================user: %@=======familyName: %@ ======= givenName: %@ ======= email: %@ ======= identityToken: %@ ======= code: %@ ", user, familyName, givenName, email, identityToken, code);
        NSLog(@"======== token: %@", [[NSString alloc] initWithData:identityToken encoding:NSUTF8StringEncoding]);
        NSLog(@"======== code: %@", [[NSString alloc] initWithData:code encoding:NSUTF8StringEncoding]);
        
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        // 使用现有的密码凭证登录
        ASPasswordCredential *credential = authorization.credential;
        
        // 用户唯一标识符
        NSString *user = credential.user;
        self.user = user;
        NSString *password = credential.password;
        NSLog(@" =========================user: %@=======password: %@ ", user, password);
        //            if (self.completeHander) {
        //                self.completeHander(YES, user, nil, nil, nil, password, nil, nil, nil, @"授权成功");
        //            }
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller
           didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    NSString *msg = @"未知";
    
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            msg = @"用户取消";
            break;
        case ASAuthorizationErrorFailed:
            msg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            msg = @"授权请求无响应";
            break;
        case ASAuthorizationErrorNotHandled:
            msg = @"授权请求未处理";
            break;
        case ASAuthorizationErrorUnknown:
            msg = @"授权失败，原因未知";
            break;
            
        default:
            break;
    }
    NSLog(@"========= msg:  %@" , msg);
}

- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0))
{
    return [UIApplication sharedApplication].windows[0] ;
}



#pragma mark- ********* check  *********

// 使用 user 信息，查询当前用户的状态
- (void) checkAuthorizationStateWithUser:(NSString *) user
                         completeHandler:(void(^)(BOOL authorized, NSString *msg)) completeHandler API_AVAILABLE(ios(13.0)) {
    user = self.user;
    if (user == nil || user.length <= 0) {
        if (completeHandler) {
            completeHandler(NO, @"用户标识符错误");
        }
        return;
    }
    
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc]init];
    [provider getCredentialStateForUserID:user completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
        
        NSString *msg = @"未知";
        BOOL authorized = NO;
        switch (credentialState) {
            case ASAuthorizationAppleIDProviderCredentialRevoked:
                msg = @"授权被撤销";
                authorized = NO;
                break;
            case ASAuthorizationAppleIDProviderCredentialAuthorized:
                msg = @"已授权";
                authorized = YES;
                break;
            case ASAuthorizationAppleIDProviderCredentialNotFound:
                msg = @"未查到授权信息";
                authorized = NO;
                break;
            case ASAuthorizationAppleIDProviderCredentialTransferred:
                msg = @"授权信息变动";
                authorized = NO;
                break;
                
            default:
                authorized = NO;
                break;
        }
        NSLog(@"============授权信息 msg: %@", msg);
    }];
}


#pragma mark- ********* keychine *********

- (void)keychine API_AVAILABLE(ios(13.0))
{
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc]init];
    ASAuthorizationAppleIDRequest *req = [provider createRequest];
    ASAuthorizationPasswordProvider *pasProvider = [[ASAuthorizationPasswordProvider alloc]init];
    ASAuthorizationPasswordRequest *pasReq = [pasProvider createRequest];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:2];
    if (req) {
        [arr addObject:req];
    }
    
    if (pasReq) {
        [arr addObject:pasReq];
    }
    
    ASAuthorizationController *controller = [[ASAuthorizationController alloc]initWithAuthorizationRequests:arr.copy];
    
    controller.delegate = self;
    controller.presentationContextProvider = self;
    [controller performRequests];
}

@end
