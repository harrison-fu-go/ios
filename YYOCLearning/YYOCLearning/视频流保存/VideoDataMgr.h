//
//  VideoDataMgr.h
//  YYOCLearning
//
//  Created by HarrisonFu on 2024/4/7.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface VideoDataMgr : NSObject
@property(nonatomic, strong)NSString *filePath;
@property(nonatomic, strong)NSString *fileName;
@property(nonatomic, assign)uint64_t fileSize;
@property(nonatomic, assign)uint64_t rcvSize;
@property(nonatomic, strong)NSString *downloadPath;
@property(nonatomic, strong)void(^endCallback)(BOOL, NSString *);
@property(nonatomic, strong)void(^progressCallback)(double);
- (instancetype)initEnd:(void(^)(BOOL, NSString *))endCallback
               progress:(void(^)(double))progressCallback;
- (void)start:(NSString *)name size:(uint64_t)fileSize;

- (void)receiveData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
