//
//  BPath.h
//  FileSystem
//
//  Created by BppleMan on 17/4/18.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BPath : NSObject <NSCopying>

@property (nonatomic, strong) NSMutableArray *pathArr;

@property (nonatomic, strong) NSMutableString *pathStr;

+ (instancetype)pathWithPath:(BPath *)path;

- (instancetype)initWithNSString:(NSString *)string;

- (void)appendenPathWithString:(NSString *)string;

- (NSString *)getLastPath;

- (NSArray *)getPathWithoutLastPath;

- (BPath *)getParentPath;
@end
