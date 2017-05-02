//
//  iNode.m
//  FileSystem
//
//  Created by BppleMan on 17/4/15.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import "iNode.h"

@implementation iNode

- (instancetype)initWithID:(NSUInteger)ID
{
    self = [super init];
    if (self)
    {
        self.userID = @"bppleman";
        self.inodeID = ID;
        self.used = NO;
        self.clusterPoint = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.fileName = [coder decodeObjectForKey:@"fileName"];
        self.userID = [coder decodeObjectForKey:@"userID"];
        self.clusterPoint = [coder decodeObjectForKey:@"clusterPoint"];
        self.fileType = [coder decodeIntegerForKey:@"fileType"];
        self.used = [coder decodeIntegerForKey:@"used"];
        self.inodeID = [coder decodeIntegerForKey:@"inodeID"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.fileName forKey:@"fileName"];
    [coder encodeObject:self.userID forKey:@"userID"];
    [coder encodeObject:self.clusterPoint forKey:@"clusterPoint"];
    [coder encodeInteger:self.fileType forKey:@"fileType"];
    [coder encodeInteger:self.used forKey:@"used"];
    [coder encodeInteger:self.inodeID forKey:@"inodeID"];
}

@end
