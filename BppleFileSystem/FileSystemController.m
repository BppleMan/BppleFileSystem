//
//  FileSystemController.m
//  FileSystem
//
//  Created by BppleMan on 17/4/15.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import "FileSystemController.h"

@implementation FileSystemController

- (instancetype)initWithFileSystemPath:(NSString *)path WithSize:(NSUInteger)size WithClusterSize:(NSUInteger)clusterSize;
{
    self = [super init];
    if (self)
    {
        _path = path;
        [self creatBppleFileSystemWithSize:size WithClusterSize:clusterSize];
    }
    return self;
}

/*
 *   以文件路径及相应参数创建文件系统
 */
- (void)creatBppleFileSystemWithSize:(NSUInteger)size WithClusterSize:(NSUInteger)clusterSize
{
    self.bppleFileSystem = [[BppleFileSystem alloc]initWithFileSize:size WithClusterSize:clusterSize];
    
    [self saveFileSystem];
}

- (instancetype)initWithFileSystemPath:(NSString *)path
{
    self = [super init];
    if (self)
    {
        _path = path;
        [self loadFileSystemInPath];
    }
    return self;
}

/**
 *  通过文件路径加载文件系统
 */
- (void)loadFileSystemInPath
{
    self.bppleFileSystem = [NSKeyedUnarchiver unarchiveObjectWithFile:_path];
}

- (void)saveFileSystem
{
    [NSKeyedArchiver archiveRootObject:self.bppleFileSystem toFile:_path];
}

- (NSMutableArray *)showFilesChildsWith:(BPath *)path
{
    if (!path)
        return nil;
    FileNode *fileNode = [self.bppleFileSystem ls:path];
    return fileNode.childs;
}

- (void)creatNewFolderWithPath:(BPath *)path
{
    [self.bppleFileSystem mkdir:path];
    [self saveFileSystem];
}

- (void)removeFileWithPath:(BPath *)path;
{
    [self.bppleFileSystem rm:path];
    [self saveFileSystem];
}

- (void)creatNewTextFileWithPath:(BPath *)path
{
    [self.bppleFileSystem vim:path];
    [self saveFileSystem];
}

- (void)writeTheTextFile:(BPath *)path With:(NSString *)stringValue
{
    [self.bppleFileSystem write:path with:[stringValue dataUsingEncoding:NSUTF8StringEncoding]];
    [self saveFileSystem];
}

- (NSString *)readTheTextFile:(BPath *)path
{
    NSData *data = [self.bppleFileSystem read:path];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
