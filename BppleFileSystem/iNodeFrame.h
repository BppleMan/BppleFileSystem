//
//  iNodeFrame.h
//  BppleFileSystem
//
//  Created by BppleMan on 17/4/29.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iNode.h"

// 索引节点的大小为2048Byte
static const NSInteger inodeSize = 2048;

@interface iNodeFrame : NSObject <NSCoding>

// 索引节点个数
@property (assign) NSUInteger inodeCount;

// 索引节点集合
@property (strong) NSMutableArray *inodes;

- (instancetype)initWithFrameSize:(NSUInteger)size;

- (iNode*)getFreeiNode;

- (void)free:(iNode*)inode;
@end
