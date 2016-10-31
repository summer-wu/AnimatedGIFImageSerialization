// AnimatedGIFImageSerialization.m
//
// Copyright (c) 2014 Mattt Thompson (http://mattt.me/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AnimatedGIFImageSerialization_Mac.h"

#import <ImageIO/ImageIO.h>

NSString * const AnimatedGIFImageErrorDomain = @"com.compuserve.gif.image.error";

//static BOOL AnimatedGifDataIsValid(NSData *data) {
//    if (data.length > 4) {
//        const unsigned char * bytes = [data bytes];
//
//        return bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46;
//    }
//
//    return NO;
//}



__attribute__((overloadable)) NSData * NSImageAnimatedGIFRepresentation(NSArray *images, NSTimeInterval duration, NSUInteger loopCount, NSError * __autoreleasing *error) {
    if (!images) {
        return nil;
    }

    NSDictionary *userInfo = nil;
    {
        size_t frameCount = images.count;
        NSTimeInterval frameDuration = duration;
        NSDictionary *frameProperties = @{
                                          (__bridge NSString *)kCGImagePropertyGIFDictionary: @{
                                                  (__bridge NSString *)kCGImagePropertyGIFDelayTime: @(frameDuration)
                                                  }
                                          };

        NSMutableData *mutableData = [NSMutableData data];
        CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)mutableData, kUTTypeGIF, frameCount, NULL);

        NSDictionary *imageProperties = @{ (__bridge NSString *)kCGImagePropertyGIFDictionary: @{
                                                   (__bridge NSString *)kCGImagePropertyGIFLoopCount: @(loopCount)
                                                   }
                                           };
        CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)imageProperties);

        for (size_t idx = 0; idx < images.count; idx++) {
            NSImage *img = images[idx];
            CGImageRef cgimg = [img CGImageForProposedRect:NULL context:NULL hints:NULL];
            CGImageDestinationAddImage(destination, cgimg, (__bridge CFDictionaryRef)frameProperties);
        }

        BOOL success = CGImageDestinationFinalize(destination);
        CFRelease(destination);

        if (!success) {
            userInfo = @{
                         NSLocalizedDescriptionKey: NSLocalizedString(@"Could not finalize image destination", nil)
                         };

            goto _error;
        }

        return [NSData dataWithData:mutableData];
    }
_error: {
    if (error) {
        *error = [[NSError alloc] initWithDomain:AnimatedGIFImageErrorDomain code:-1 userInfo:userInfo];
    }
    
    return nil;
    }
}


@implementation AnimatedGIFImageSerialization

+ (NSData *)animatedGIFDataWithImages:(NSArray <NSImage *> *)images
                             duration:(NSTimeInterval)duration
                            loopCount:(NSUInteger)loopCount
                                error:(NSError * __autoreleasing *)error
{
    return NSImageAnimatedGIFRepresentation(images, duration, loopCount, error);
}

@end
