//
//  SceneDelegate.m
//  YYRuntime
//
//  Created by 符华友 on 2021/12/9.
//

#import "SceneDelegate.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    NSLog(@"======= willConnectToSession ======");
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    NSLog(@"======= sceneDidDisconnect ======");
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    NSLog(@"======= sceneDidBecomeActive ======");
}


- (void)sceneWillResignActive:(UIScene *)scene {
    NSLog(@"======= sceneWillResignActive ======");
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    NSLog(@"======= sceneWillEnterForeground ======");
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    NSLog(@"======= sceneDidEnterBackground ======");
}


@end
