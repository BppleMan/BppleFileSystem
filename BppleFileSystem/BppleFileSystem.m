//
//  FileSystem.m
//  FileSystem
//
//  Created by BppleMan on 17/4/15.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import "BppleFileSystem.h"

@implementation BppleFileSystem

- (instancetype)initWithFileSize:(NSUInteger)fileSize WithClusterSize:(NSUInteger)clusterSize
{
    self = [super init];
    if (self)
    {
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]];
        self.headFrame = [[HeadFrame alloc]initWithCreatTime:date lastTime:date SIZE:fileSize];
        self.inodeFrame = [[iNodeFrame alloc] initWithFrameSize:fileSize / 100];
        self.dataFrame = [[DataFrame alloc] initWithDataSize:fileSize * 99 / 100 ClusterSize:clusterSize];
        [self initCataTree];
        
        //        [self.cataTree sequenceTraversalFromRootNode];
    }
    return self;
}

- (void)initCataTree
{
    self.cataTree = [[CataTree alloc]init];
    iNode *inode;
    
    //    创建root目录
    inode = [self.inodeFrame getFreeiNode];
    [inode setFileName:@"root"];
    [inode setFileType:BppleDirectoryType];
    [self.cataTree creatRootNodeWith:inode];
    
    //    创建HOME目录
    inode = [self.inodeFrame getFreeiNode];
    [inode setFileName:@"HOME"];
    [inode setFileType:BppleDirectoryType];
    FileNode *homeNode = [[FileNode alloc] initWithiNode:inode];
    [self.cataTree addFileNode:homeNode ToParent:self.cataTree.rootNode];
    
    //    创建应用程序@"应用程序", @"桌面", @"文稿", @"下载", @"影片", @"音乐", @"图片"目录
    NSMutableArray *dirName = [NSMutableArray arrayWithObjects:@"应用程序", @"桌面", @"文稿", @"下载", @"影片", @"音乐", @"图片", nil];
    for (NSString *name in dirName)
    {
        inode = [self.inodeFrame getFreeiNode];
        [inode setFileName:name];
        [inode setFileType:BppleDirectoryType];
        FileNode *fileNode = [[FileNode alloc] initWithiNode:inode];
        [self.cataTree addFileNode:fileNode ToParent:homeNode];
    }
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.headFrame = [coder decodeObjectForKey:@"headFrame"];
        self.inodeFrame = [coder decodeObjectForKey:@"inodeFrame"];
        self.dataFrame = [coder decodeObjectForKey:@"dataFrame"];
        self.cataTree = [coder decodeObjectForKey:@"cataTree"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.headFrame forKey:@"headFrame"];
    [coder encodeObject:self.inodeFrame forKey:@"inodeFrame"];
    [coder encodeObject:self.dataFrame forKey:@"dataFrame"];
    [coder encodeObject:self.cataTree forKey:@"cataTree"];
}

- (FileNode *)cd:(BPath *)path
{
    FileNode *fileNode = [self.cataTree findFileNodeWithPath:path inRoot:self.cataTree.rootNode];
    return fileNode;
}

- (FileNode *)ls:(BPath *)path
{
    FileNode *fileNode = [self.cataTree findFileNodeWithPath:path inRoot:self.cataTree.rootNode];
    return fileNode;
}

- (BOOL)mkdir:(BPath *)path
{
    if ([self.cataTree findFileNodeWithPath:path inRoot:self.cataTree.rootNode] != nil)
        return NO;
    NSString    *name = [path getLastPath];
    iNode       *inode = [self.inodeFrame getFreeiNode];
    [inode setFileName:name];
    [inode setFileType:BppleDirectoryType];
    FileNode *fileNode = [[FileNode alloc] initWithiNode:inode];
    [self.cataTree addFileNode:fileNode ToPath:[path getParentPath]];
    return YES;
}

- (void)rm:(BPath *)path
{
    FileNode *fileNode = [self.cataTree findFileNodeWithPath:path inRoot:self.cataTree.rootNode];
    [self.dataFrame free:fileNode.inode.clusterPoint];
    [self.inodeFrame free:fileNode.inode];
    FileNode *parent = fileNode.parent;
    [parent removeChildsObject:fileNode];
}

- (BOOL)vim:(BPath *)path
{
    if ([self.cataTree findFileNodeWithPath:path inRoot:self.cataTree.rootNode] != nil)
    {
        return NO;
    }
    NSString    *name = [path getLastPath];
    iNode       *inode = [self.inodeFrame getFreeiNode];
    [inode setFileName:name];
    [inode setFileType:BppleTextFileType];
    FileNode *fileNode = [[FileNode alloc] initWithiNode:inode];
    [self.cataTree addFileNode:fileNode ToPath:[path getParentPath]];
    return YES;
}

- (void)write:(BPath *)path with:(NSData *)data
{
    FileNode *fileNode = [self.cataTree findFileNodeWithPath:path inRoot:self.cataTree.rootNode];
    [fileNode setDataLength:data.length];
    [self.dataFrame writeDataWith:data WithFileNode:fileNode];
}

- (BOOL)rename:(BPath *)path with:(NSString *)newName
{
    BPath *newPath = [path getParentPath];
    [newPath appendenPathWithString:newName];
    if ([self.cataTree findFileNodeWithPath:newPath inRoot:self.cataTree.rootNode] != nil)
        return NO;
    FileNode *fileNode = [self.cataTree findFileNodeWithPath:path inRoot:self.cataTree.rootNode];
    [fileNode.inode setFileName:newName];
    return YES;
}

- (NSData *)read:(BPath *)path
{
    FileNode *fileNode = [self.cataTree findFileNodeWithPath:path inRoot:self.cataTree.rootNode];
    return [self.dataFrame readDataWithFileNode:fileNode];
}

- (void)cp:(BPath *)oldPath to:(BPath *)newPath
{
    FileNode    *oldNode = [self.cataTree findFileNodeWithPath:oldPath inRoot:self.cataTree.rootNode];
    NSString    *name = [newPath getLastPath];
    iNode       *inode = [self.inodeFrame getFreeiNode];
    [inode setFileName:name];
    [inode setFileType:[oldNode.inode fileType]];
    [inode.clusterPoint addObjectsFromArray:[oldNode.inode clusterPoint]];
    FileNode *fileNode = [[FileNode alloc] initWithiNode:inode];
    [fileNode.childs addObjectsFromArray:oldNode.childs];
    [fileNode setDataLength:oldNode.dataLength];
    [self.cataTree addFileNode:fileNode ToPath:[newPath getParentPath]];
}

+ (NSInteger)getDefaultFileSize
{
    return DefaultFileSize;
}

@end
