//
//  CataLog.h
//  FileSystem
//
//  Created by BppleMan on 17/4/15.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileNode.h"
#import "BPath.h"

@interface CataTree : NSObject <NSCoding>

@property (nonatomic, strong) FileNode *rootNode;

- (void)creatRootNodeWith:(iNode *)inode;

- (void)creatFileNodeWith:(iNode *)inode ToParent:(FileNode *)parentNode;

- (void)addFileNodeWith:(iNode *)inode ToPath:(BPath *)path;

- (FileNode *)findFileNodeWithiNode:(iNode *)inode;

- (FileNode *)findFileNodeWithPath:(BPath *)path inRoot:(FileNode *)root;

- (void)creatFileNodeWithPath:(BPath *)path iNode:(iNode *)inode;

- (void)sequenceTraversalFromRootNode;

@end
