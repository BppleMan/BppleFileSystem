//
//  FileNode.h
//  FileSystem
//
//  Created by BppleMan on 17/4/18.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iNode.h"

@interface FileNode : NSObject <NSCoding>

// @property (nonatomic, strong) NSMutableData *data;

@property (nonatomic, strong) NSMutableArray *childs;

@property (nonatomic, strong) iNode *inode;

@property (nonatomic, strong) FileNode *parent;

@property (nonatomic,assign) NSUInteger dataLength;

- (instancetype)initWithiNode:(iNode *)inode;

- (void)addChildsObject:(FileNode *)child;

- (void)removeChildsAtIndexes:(NSUInteger)index;

- (void)removeChildsObject:(FileNode *)child;

@end
