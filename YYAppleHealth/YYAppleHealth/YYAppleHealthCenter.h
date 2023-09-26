//
//  YYAppleHealthCenter.h
//  YYAppleHealth
//
//  Created by yy.Fu on 2020/12/28.
//

#import <Foundation/Foundation.h>

@interface YYAppleHealthCenter : NSObject

-(void)requestAuthorization;

- (void)getStatus;

- (void)postData;

@end

