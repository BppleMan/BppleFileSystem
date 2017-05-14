//
//  CataLog.m
//  FileSystem
//
//  Created by BppleMan on 17/4/15.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import "CataTree.h"

@implementation CataTree

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.rootNode = [coder decodeObjectForKey:@"rootNode"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.rootNode forKey:@"rootNode"];
}

- (void)creatRootNodeWith:(iNode *)inode
{
    self.rootNode = [[FileNode alloc] initWithiNode:inode];
    [self.rootNode setParent:nil];
}

- (void)addFileNode:(FileNode *)fileNode ToPath:(BPath *)path;
{
    FileNode *parent = [self findFileNodeWithPath:path inRoot:self.rootNode];
    [self addFileNode:fileNode ToParent:parent];
}

- (void)addFileNode:(FileNode *)fileNode ToParent:(FileNode *)parent
{
    [parent addChildsObject:fileNode];
    [fileNode setParent:parent];
}

- (NSMutableArray *)LSFileNodeWithFileName:(NSString *)fileName
{
    return nil;
}

- (void)creatFileNodeWithPath:(BPath *)path iNode:(iNode *)inode
{
    //    先根据路径找到父节点
    NSArray     *arr = [path pathArr];
    FileNode    *parentNode = _rootNode;
    for (int i = 1; i < [arr count] - 1; i++)
    {
        parentNode = [self findFileNodeWithName:arr[i] inRoot:parentNode];
    }
    //    创建自身节点
    FileNode *fileNode = [[FileNode alloc]initWithiNode:inode];
    //    将自身节点添加到父节点的子节点数组中
    [parentNode addChildsObject:fileNode];
    //    设置自身的父节点
    [fileNode setParent:parentNode];
}

- (FileNode *)findFileNodeWithPath:(BPath *)path inRoot:(FileNode *)root
{
    FileNode    *result = nil;
    FileNode    *finded = self.rootNode;
    for (NSString *name in [path pathArr])
    {
        finded = [self findFileNodeWithName:name inRoot:finded];
        result = finded;
    }
    return result;
}

/**
 *  从根节点层序遍历树 查找名为name的节点
 *
 *  @param name 需查找的节点名称
 *  @param root 根节点
 *
 *  @return 返回查找到的FileNode
 */
- (FileNode *)findFileNodeWithName:(NSString *)name inRoot:(FileNode *)root
{
    NSMutableArray *nodeQueue = [[NSMutableArray alloc]init];
    [nodeQueue addObject:root];
    FileNode *result = nil;
    while ([nodeQueue count] != 0)
    {
        FileNode *node = nodeQueue[0];
        [nodeQueue removeObjectAtIndex:0];
        if ([[[node inode] fileName] isEqualToString:name])
        {
            result = node;
            break;
        }
        else
            [nodeQueue addObjectsFromArray:[node childs]];
    }
    return result;
}

/**
 *  从根节点层序遍历整个树并打印每个节点
 */
- (void)sequenceTraversalFromRootNode
{
    NSMutableArray *nodeQueue = [[NSMutableArray alloc]init];
    [nodeQueue addObject:_rootNode];
    while ([nodeQueue count] != 0)
    {
        FileNode *node = nodeQueue[0];
        [nodeQueue removeObjectAtIndex:0];
        
        NSLog(@"%@", node);
        
        [nodeQueue addObjectsFromArray:[node childs]];
    }
}

@end
