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
    [self.cataTree creatFileNodeWith:inode ToParent:self.cataTree.rootNode];
    
    //    创建应用程序@"应用程序", @"桌面", @"文稿", @"下载", @"影片", @"音乐", @"图片"目录
    NSMutableArray  *dirName = [NSMutableArray arrayWithObjects:@"应用程序", @"桌面", @"文稿", @"下载", @"影片", @"音乐", @"图片", nil];
    FileNode        *homeNode = [self.cataTree findFileNodeWithPath:[[BPath alloc] initWithNSString:@"root/HOME"] inRoot:self.cataTree.rootNode];
    for (NSString *name in dirName)
    {
        inode = [self.inodeFrame getFreeiNode];
        [inode setFileName:name];
        [inode setFileType:BppleDirectoryType];
        [self.cataTree creatFileNodeWith:inode ToParent:homeNode];
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

- (void)mkdir:(BPath *)path
{
    NSString    *name = [path getLastPath];
    iNode       *inode = [self.inodeFrame getFreeiNode];
    [inode setFileName:name];
    [inode setFileType:BppleDirectoryType];
    [self.cataTree addFileNodeWith:inode ToPath:path];
}

- (void)rm:(BPath *)path
{
    FileNode *fileNode = [self.cataTree findFileNodeWithPath:path inRoot:self.cataTree.rootNode];
    [self.dataFrame free:fileNode.inode.clusterPoint];
    [self.inodeFrame free:fileNode.inode];
    FileNode *parent = fileNode.parent;
    [parent removeChildsObject:fileNode];
}

- (void)vim:(BPath *)path
{
    NSString    *name = [path getLastPath];
    iNode       *inode = [self.inodeFrame getFreeiNode];
    [inode setFileName:name];
    [inode setFileType:BppleTextFileType];
    [self.cataTree addFileNodeWith:inode ToPath:path];
}

- (void)write:(BPath *)path with:(NSData *)data
{
    FileNode *fileNode = [self.cataTree findFileNodeWithPath:path inRoot:self.cataTree.rootNode];
    [fileNode setDataLength:data.length];
    [self.dataFrame writeDataWith:data WithFileNode:fileNode];
}

- (NSData *)read:(BPath *)path
{
    FileNode *fileNode = [self.cataTree findFileNodeWithPath:path inRoot:self.cataTree.rootNode];
    return [self.dataFrame readDataWithFileNode:fileNode];
}

+ (NSInteger)getDefaultFileSize
{
    return DefaultFileSize;
}

@end
