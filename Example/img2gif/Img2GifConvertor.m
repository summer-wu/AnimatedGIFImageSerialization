//
//  Img2GifConvertor.m
//  Animated GIF Example
//
//  Created by n on 16/10/31.
//  Copyright © 2016年 Mattt Thompson. All rights reserved.
//

#import "Img2GifConvertor.h"
#import "AnimatedGIFImageSerialization_Mac.h"

@implementation Img2GifConvertor
+ (void)extractFromGif:(NSString *)gifPath{
    //还没有实现
}


+ (void)createGifFromFilepaths:(NSArray *)filepaths{
    NSMutableArray *imgs = [NSMutableArray array];
    for (NSString *path in filepaths) {
        NSImage *img = [[NSImage alloc]initWithContentsOfFile:path];
        if (img) {
            [imgs addObject:img];
        } else {
            NSLog(@"文件创建NSImage失败 %@",img);
        }
    }
    NSError *err;
    NSData *data = [AnimatedGIFImageSerialization animatedGIFDataWithImages:imgs duration:0.1 loopCount:0 error:&err];
    if (err) {
        NSLog(@"创建gif时出错:%@",err);
    } else {
        [data writeToFile:@"1.gif" atomically:YES];
    }
}
@end
