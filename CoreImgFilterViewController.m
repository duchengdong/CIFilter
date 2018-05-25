//
//  CoreImgFilterViewController.m
//  Movie
//
//  Created by cddu on 2018/5/24.
//  Copyright © 2018年 cddu. All rights reserved.
//

#import "CoreImgFilterViewController.h"
#import "AVFoundation/AVFoundation.h"

@interface CoreImgFilterViewController ()
@property(nonatomic,strong)NSURL *filePath;
@end

@implementation CoreImgFilterViewController
-(instancetype)initWithVideoUrl:(NSURL *)videoUrl{
    self = [super init];
    if (self) {
        _filePath = videoUrl;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    AVAsset *videoAsset = [AVURLAsset URLAssetWithURL:_filePath options:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
    AVVideoComposition *composition = [AVVideoComposition videoCompositionWithAsset:videoAsset applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request) {
        NSLog(@"导出中");
        CIImage *source = request.sourceImage;
        [filter setValue:source forKey:@"inputImage"];
        CIImage *resultImage = [filter valueForKey:@"outputImage"];
        [request finishWithImage:resultImage context:nil];
    }];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]initWithAsset:videoAsset presetName:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = composition ;
    exporter.outputURL = [NSURL fileURLWithPath:[self fileSavePathWithFileName:@"test"]];
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        switch (exporter.status) {
            case AVAssetExportSessionStatusFailed:
                NSLog(@"exporting failed %@",[exporter error]);
                break;
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"导出完成");
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"export cancelled");
                break;
            case AVAssetExportSessionStatusUnknown:
                
                break;
            case AVAssetExportSessionStatusWaiting:
                
                break;
            case AVAssetExportSessionStatusExporting:
                
                break;
        }

    }];

}
-(NSString *)fileSavePathWithFileName:(NSString *)fileName{
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/Vidio/%@.mp4", DOCUMENTPATH,fileName];//视频存放位置
    NSString *folderPath = [NSString stringWithFormat:@"%@/Vidio", DOCUMENTPATH];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (blHave) {
        BOOL blDele= [fileManager removeItemAtPath:filePath error:nil];
        if (!blDele) {
            [fileManager removeItemAtPath:filePath error:nil];
        }
    }
    //判断视频存放文件夹是否存在，不存在创建
    BOOL blHave1=[[NSFileManager defaultManager] fileExistsAtPath:folderPath];
    if (!blHave1) {
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
   
    
    NSLog(@"视频输出地址 fileSavePath = %@",filePath);
    
    return filePath;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
