//
//  CommandLineParser.h
//  base62
//
//  Created by n on 16/10/13.
//  Copyright © 2016年 summerwu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CommandLineAction) {
    CommandLineActionDecode,
    CommandLineActionEncode,
    CommandLineActionHelp,//Help就是Usage
};

@interface CommandLineParser : NSObject
- (instancetype)initWithArgc:(int)argc argv:(char **) argv;
@property (nonatomic,readonly) CommandLineAction action;///< 经过解析，获得的action
@property (nonatomic,readonly) NSArray *filepaths;///< 命令行上的文件名补全路径后的filepath
@end
