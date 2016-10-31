//
//  Img2GifConvertor.h
//  Animated GIF Example
//
//  Created by n on 16/10/31.
//  Copyright © 2016年 Mattt Thompson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Img2GifConvertor : NSObject
+ (void)extractFromGif:(NSString *)gifPath;
+ (void)createGifFromFilepaths:(NSArray *)filepaths;
@end
