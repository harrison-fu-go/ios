//
//  VideoDataMgr.m
//  YYOCLearning
//
//  Created by HarrisonFu on 2024/4/7.
//

#import "VideoDataMgr.h"

@interface VideoDataMgr()

@property(nonatomic, strong)NSFileHandle *fileHandle;

@end

@implementation VideoDataMgr

- (instancetype)initEnd:(void(^)(BOOL, NSString *))endCallback
               progress:(void(^)(double))progressCallback {
    self = [super init];
    if (self) {
        self.endCallback = endCallback;
        self.progressCallback = progressCallback;
    }
    return self;
}

- (BOOL)createFilePath {
    self.downloadPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:@"/downloads"];
    BOOL isDirectory;
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.downloadPath isDirectory:&isDirectory]) {
        NSURL *fileUrl = [NSURL fileURLWithPath:self.downloadPath];
        BOOL isSuccess = [[NSFileManager defaultManager] createDirectoryAtURL:fileUrl
                                                  withIntermediateDirectories:YES
                                                                   attributes:nil error:nil];
        if (!isSuccess) {
            NSLog(@"======= 目录创建失败");
            return NO;
        }
    }
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", self.downloadPath, self.fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    BOOL isSuccess = [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    if (isSuccess) {
        NSLog(@"******** 创建文件成功");
        self.filePath = filePath;
        self.fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.filePath];
        return YES;
    }
    NSLog(@"******** 目录创建失败");
    return NO;
}

- (void)start:(NSString *)name size:(uint64_t)fileSize {
    self.fileName = name;
    self.fileSize = fileSize;
    self.rcvSize = 0;
    BOOL s = [self createFilePath];
    if (!s) {
        if (self.endCallback) {
            self.endCallback(NO, @"Create File Path error");
        }
    }
}

- (void)receiveData:(NSData *)data {
    if (!self.filePath) {
        NSLog(@"******** Target file page not found. ");
        return;
    }
    [self.fileHandle seekToEndReturningOffset:nil error:nil];
    [self.fileHandle writeData:data error:nil];
    self.rcvSize = self.rcvSize + data.length;
    [self updateProgress];
}

- (void)updateProgress {
    dispatch_async(dispatch_get_main_queue(), ^{
        double progress = (double)self.rcvSize / (double)self.fileSize;
        if (self.progressCallback) {
            self.progressCallback(progress);
        }
        NSLog(@"******** self.rcvSize: %d===  self.fileSize %d === 等？： %d", self.rcvSize, self.fileSize, self.rcvSize == self.fileSize);
        if (self.rcvSize == self.fileSize) {
            [self finishedFileHandle];
            [self putMp4ToPhotoAlbum];
        }
    });
}

- (void)putMp4ToPhotoAlbum {
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.filePath)) {
        UISaveVideoAtPathToSavedPhotosAlbum(self.filePath,
                                            self,
                                            @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
        NSLog(@"save error%@", error.localizedDescription);
        if (self.endCallback) {
            self.endCallback(NO, @"video save to album error!");
        }
    }
    else {
        NSLog(@"save success");
        if (self.endCallback) {
            self.endCallback(YES, @"successfully!");
        }
    }
}

- (void)finishedFileHandle {
    if (self.fileHandle) {
        [self.fileHandle closeFile];
        self.fileHandle = nil;
    }
}

- (void)dealloc {
    [self finishedFileHandle];
}

@end
