//
//  BPath.m
//  FileSystem
//
//  Created by BppleMan on 17/4/18.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import "BPath.h"

@implementation BPath

- (instancetype)initWithNSString:(NSString *)string
{
    self = [super init];
    if (self)
    {
        self.pathArr = [NSMutableArray arrayWithArray:[string componentsSeparatedByString:@"/"]];
        self.pathStr = [NSMutableString stringWithString:string];
    }
    return self;
}

+ (instancetype)pathWithPath:(BPath *)path
{
    BPath *selfPath = [[BPath alloc] initWithNSString:path.pathStr];
    return selfPath;
}

- (void)appendenPathWithString:(NSString *)string
{
    [self.pathArr addObject:string];
    [self.pathStr appendFormat:@"/%@", string];
}

- (NSString *)getLastPath
{
    return [self.pathArr lastObject];
}

- (NSArray *)getPathWithoutLastPath
{
    return [NSArray arrayWithArray:[self.pathArr subarrayWithRange:NSMakeRange(0, self.pathArr.count - 1)]];
}

- (id)copyWithZone:(NSZone *)zone
{
    BPath *copy = [[BPath alloc] init];
    copy.pathArr = [self.pathArr mutableCopy];
    copy.pathStr = [self.pathStr mutableCopy];
    return copy;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", self.pathStr];
}

- (BOOL)isEqual:(id)other
{
    if (other == self)
    {
        return YES;
    }
    else if (![super isEqual:other])
    {
        return NO;
    }
    else
    {
        BPath *otherPath = (BPath *)other;
        return [self.pathStr isEqual:otherPath.pathStr];
    }
}

- (NSUInteger)hash
{
    return [super hash];
}

@end
