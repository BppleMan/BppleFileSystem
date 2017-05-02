//
//  iNodeFrame.m
//  BppleFileSystem
//
//  Created by BppleMan on 17/4/29.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import "iNodeFrame.h"

@implementation iNodeFrame

- (instancetype)initWithFrameSize:(NSUInteger)size;
{
    self = [super init];
    if (self)
    {
        self.inodeCount = size / inodeSize;
        self.inodes = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.inodeCount; i++)
        {
            iNode *inode = [[iNode alloc] initWithID:i];
            [self.inodes addObject:inode];
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.inodes = [coder decodeObjectForKey:@"inodes"];
        self.inodeCount = [coder decodeIntegerForKey:@"inodeCount"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.inodes forKey:@"inodes"];
    [coder encodeInteger:self.inodeCount forKey:@"inodeCount"];
}

- (iNode *)getFreeiNode
{
    iNode *result = nil;
    for (iNode *temp in self.inodes)
    {
        if (![temp used])
        {
            [temp setUsed:YES];
            result = temp;
            break;
        }
    }
    return result;
}

- (void)free:(iNode *)inode
{
    [inode setUsed:NO];
}

@end
