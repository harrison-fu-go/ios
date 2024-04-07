//
//  ViewController.m
//  YYOCLearning
//
//  Created by HarrisonFu on 2024/4/7.
//

#import "ViewController.h"
#import "VideoDataMgr.h"
@interface ViewController ()
@property(nonatomic, strong)NSString *downloadPath;
@property(nonatomic, strong)VideoDataMgr *videoMgr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.downloadPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject] stringByAppendingPathComponent:@"/downloads"];
    BOOL isDirectory;
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.downloadPath isDirectory:&isDirectory]) {
        NSURL *fileUrl = [NSURL fileURLWithPath:self.downloadPath];
        BOOL isSuccess = [[NSFileManager defaultManager] createDirectoryAtURL:fileUrl
                                                  withIntermediateDirectories:YES
                                                                   attributes:nil error:nil];
        if (isSuccess) {
            NSLog(@"目录创建成功");
        } else {
            NSLog(@"目录创建失败");
        }
    }
//    [self saveDemoFile];
//    [self putToPhotoAlbum];
    
//    [self saveDemoMp4File];
//    [self putMp4ToPhotoAlbum];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.videoMgr = [[VideoDataMgr alloc] initEnd:^(BOOL success, NSString *mess) {
            NSLog(@"=====end: %d === %@", success, mess);
        } progress:^(double progress) {
            NSLog(@"=====progress: %f", progress);
        }];
        NSString *fileName = @"sample-15s.mp4";
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        [self.videoMgr start:fileName size:data.length];
        BOOL isFinished = NO;
        uint32_t intervalLen = 100000;
        uint32_t loc = 0;
        uint32_t totoalLen = (uint32_t)data.length;
        while (!isFinished) {
            uint32_t sendLength = intervalLen;
            if (loc + intervalLen > totoalLen-1) {
                sendLength = totoalLen - loc;
            }
            NSRange sendRange = NSMakeRange(loc, sendLength);
            NSData *sendData = [data subdataWithRange:sendRange];
            [self.videoMgr receiveData:sendData];
            [NSThread sleepForTimeInterval:0.01];
            loc = loc + sendLength;
            if (loc == totoalLen) { //end.
                isFinished = YES;
                NSLog(@"=====end: %d === %d ==== %d", loc, (totoalLen - loc), totoalLen);
            }
        }
    });
    
    
}

//- (void)saveDemoMp4File {
//    NSString *fileName = @"sample-15s.mp4";
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
//    NSData *data = [NSData dataWithContentsOfFile:filePath];
//    [data writeToFile:[NSString stringWithFormat:@"%@/%@", self.downloadPath, fileName] atomically:YES];
//}
//
//- (void)putMp4ToPhotoAlbum {
//    NSString *path = [NSString stringWithFormat:@"%@/sample-15s.mp4", self.downloadPath];
//    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
//        UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
//    }
//}
//
//- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//    if (error) {
//        [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
//        NSLog(@"save error%@", error.localizedDescription);
//    }
//    else {
//        NSLog(@"save success");
//    }
//}

- (void)saveDemoFile {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"system" ofType:@"jpg"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    [data writeToFile:[NSString stringWithFormat:@"%@/system.jpg", self.downloadPath] atomically:YES];
}


- (void)putToPhotoAlbum {
    NSString *path = [NSString stringWithFormat:@"%@/system.jpg", self.downloadPath];
    UIImage *imge= [UIImage imageWithContentsOfFile:path];
    if (imge) {
        UIImageWriteToSavedPhotosAlbum(imge,
                                       self,
                                       @selector(image:savedInPhotoAlbumWithError:usingContextInfo:),
                                       nil);
    }
}

- (void)image:(UIImage *)image savedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        // Do anything needed to handle the error or display it to the user
    } else {
        // .... do anything you want here to handle
        // .... when the image has been saved in the photo album
    }
}




@end
