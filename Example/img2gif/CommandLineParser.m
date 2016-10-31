//
//  CommandLineParser.m
//  base62
//
//  Created by n on 16/10/13.
//  Copyright © 2016年 summerwu. All rights reserved.
//

#import "CommandLineParser.h"

#define kFM [NSFileManager defaultManager]


@interface CommandLineParser ()
@property (nonatomic,strong) NSMutableArray *argv;
@property (nonatomic,strong) NSArray *filepaths;
@end

@implementation CommandLineParser
- (instancetype)initWithArgc:(int)argc argv:(char **) argv
{
    self = [super init];
    if (self) {

        //创建argv数组
        self.argv = [NSMutableArray array];
        for (int i=0; i<argc; i++) {
            char *cstr = argv[i];
            NSString *ocstr = [NSString stringWithCString:cstr encoding:NSUTF8StringEncoding];
            [self.argv addObject:ocstr];
        }

    }
    return self;
}

- (CommandLineAction)action{
    //首先argv.count要为3，否则就是help
    if (self.argv.count < 3) {
        return CommandLineActionHelp;
    }

    BOOL contains_d = [self.argv containsObject:@"-d"];
    if (contains_d) {
        return CommandLineActionDecode;
    }

    BOOL contains_e = [self.argv containsObject:@"-e"];
    if (contains_e) {
        return CommandLineActionEncode;
    }

    return CommandLineActionHelp;
}

- (NSArray *)filepaths{
    if (!_filepaths) {
        NSMutableArray *argv_afterRemove0 = self.argv;
        NSMutableArray *existFiles = [NSMutableArray array];
        [argv_afterRemove0 removeObjectAtIndex:0];//移除-d或-e
        NSString *currentDir = [kFM currentDirectoryPath];
        for (NSString *name in argv_afterRemove0) {
            BOOL firstCharIsSlash = [[name substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"/"];
            if (firstCharIsSlash) {
                BOOL exists = [kFM fileExistsAtPath:name];
                if (exists) {
                    [existFiles addObject:name];
                }
            } else {
                NSString *fullPath = [currentDir stringByAppendingPathComponent:name];
                BOOL exists = [kFM fileExistsAtPath:fullPath];
                if (exists) {
                    [existFiles addObject:name];
                }
            }
        }
        NSLog(@"input is : %@", argv_afterRemove0);
        NSLog(@"exist is : %@", existFiles);
        _filepaths = [NSArray arrayWithArray:existFiles];
    }
    return _filepaths;
}


@end
