//
//  FileNode.m
//  FileSystem
//
//  Created by BppleMan on 17/4/18.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import "FileNode.h"

@implementation FileNode

- (instancetype)initWithiNode:(iNode *)inode
{
    self = [super init];
    if (self)
    {
        self.childs = [[NSMutableArray alloc]init];
        self.inode = inode;
        self.dataLength = 0;
        self.parent = nil;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.childs = [coder decodeObjectForKey:@"childs"];
        self.inode = [coder decodeObjectForKey:@"inode"];
        self.parent = [coder decodeObjectForKey:@"parent"];
        self.dataLength = [coder decodeIntegerForKey:@"dataLength"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.childs forKey:@"childs"];
    [coder encodeObject:self.inode forKey:@"inode"];
    [coder encodeObject:self.parent forKey:@"parent"];
    [coder encodeInteger:self.dataLength forKey:@"dataLength"];
}

- (void)addChildsObject:(FileNode *)child
{
    if (_childs)
        [_childs addObject:child];
}

- (void)removeChildsObject:(FileNode *)child
{
    if (_childs)
        [_childs removeObject:child];
}

- (void)removeChildsAtIndexes:(NSUInteger)index
{
    if (_childs)
        [_childs removeObjectAtIndex:index];
}

- (NSString *)description
{
    NSString *result = [NSString stringWithFormat:@"[self:%@ childs:%@]", [_inode fileName], self.childs];
    return result;
}

@end
