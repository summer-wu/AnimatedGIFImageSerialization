//
//  main.m
//  base62
//
//  Created by n on 16/10/13.
//  Copyright © 2016年 summerwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommandLineParser.h"
#import "Img2GifConvertor.h"

void printArgcArgv(int argc, char * argv[]){
    printf("-------enter main method, printArgcArgv:-------\n");
    for (int i=0; i<argc; i++) {
        printf("%d: %s\n",i,argv[i]);
    }
    printf("-------printArgcArgv end---------\n");
}


void printHelp(){
    printf("Help:\n"
           "decode or encode gif.\n"
           "if -d,will output %%2d.png to current directory.\n"
           "if -e,will output 1.git to current directory. \n"
           "img2gif -d 1.gif #decode 1.gif\n"
           "img2gif -e *.png #encode all png to 1.gif\n"
           "img2gif #print help\n");
}

int main(int argc, char * argv[]) {
    @autoreleasepool {
        printArgcArgv(argc, argv);
        CommandLineParser *parser = [[CommandLineParser alloc]initWithArgc:argc argv:argv];
        switch (parser.action) {
            case CommandLineActionDecode:
                if ( parser.filepaths.count >= 1) {
                    NSString *gifPath = parser.filepaths[0];
                    [Img2GifConvertor extractFromGif:gifPath];
                } else {
                    NSLog(@"-d 但filepaths.count不够");
                    printHelp();
                }
                break;
            case CommandLineActionEncode:
                if ( parser.filepaths.count >= 1) {
                    [Img2GifConvertor createGifFromFilepaths:parser.filepaths];
                } else {
                    NSLog(@"-e 但filepaths.count不够");
                    printHelp();
                }
                break;
            case CommandLineActionHelp:
                printHelp();
                break;
        }
    }
    return 0;
}
