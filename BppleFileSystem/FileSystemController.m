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

- (NSMutableArray *)showFileChildsWith:(BPath *)path
{
    if (!path)
        return nil;
    FileNode *fileNode = [self.bppleFileSystem ls:path];
    return fileNode.childs;
}

- (FileAction)creatNewFolderWithPath:(BPath *)path
{
    FileAction result;
    if ([self.bppleFileSystem mkdir:path])
    {
        result = SUCCESS;
        [self saveFileSystem];
    }
    else
        result = SAMENAME;
    return result;
}

- (void)removeFileWithPath:(BPath *)path;
{
    [self.bppleFileSystem rm:path];
    [self saveFileSystem];
}

- (FileAction)creatNewTextFileWithPath:(BPath *)path
{
    FileAction result;
    if ([self.bppleFileSystem vim:path])
    {
        result = SUCCESS;
        [self saveFileSystem];
    }
    else
        result = SAMENAME;
    return result;
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

- (FileAction)renameFileWith:(BPath *)path WithNewName:(NSString *)newName
{
    FileAction result;
    if ([self.bppleFileSystem rename:path with:newName])
    {
        result = SUCCESS;
        [self saveFileSystem];
    }
    else
        result = SAMENAME;
    return result;
}

- (FileAction)transferFileWithStringPath:(NSString *)stringPath IntoFileSystemWithBPath:(BPath *)filePath
{
    FileAction              result = FAILED;
    NSArray <NSString *>    *pathArr = [stringPath componentsSeparatedByString:@"/"];
    if ([[pathArr.lastObject pathExtension] isEqual:@"txt"])
    {
        BPath *path = [BPath pathWithPath:filePath];
        [path appendenPathWithString:[pathArr lastObject]];
        NSFileHandle    *fileHandle = [NSFileHandle fileHandleForReadingAtPath:stringPath];
        NSData          *fileData = [fileHandle readDataToEndOfFile];
        if ([_bppleFileSystem vim:path])
        {
            result = SUCCESS;
            [_bppleFileSystem write:path with:fileData];
            [self saveFileSystem];
        }
        else
            result = SAMENAME;
        [fileHandle closeFile];
    }
    return result;
}

- (FileAction)cloneFileWithOldPath:(BPath *)oldPath IntoNewPath:(BPath *)newPath
{
    [self.bppleFileSystem cp:oldPath to:newPath];
    [self saveFileSystem];
    return SUCCESS;
}

- (NSString *)creatFileInRealSystemWithPath:(BPath *)filePath
{
    FileNode        *fileNode = [self.bppleFileSystem ls:filePath];
    NSFileManager   *fileManager = [NSFileManager defaultManager];
    NSString        *cache = [fileManager applicationCacheDirectory];
    NSString        *path = nil;
    NSData          *data = nil;
    switch (fileNode.inode.fileType)
    {
        case BppleTextFileType:
        {
            path = [NSString stringWithFormat:@"%@/%@", cache, fileNode.inode.fileName];
            data = [self.bppleFileSystem read:filePath];
            [fileManager createFileAtPath:path contents:data attributes:nil];
            break;
        }
        case BppleDirectoryType:
        {
            break;
        }
    }
    return path;
}

////递归建立目录树
// - (void)creatFolder:(FileNode *)fileNode To:(NSString *)path
// {
//    NSFileManager   *fileManager = [NSFileManager defaultManager];
//    switch (fileNode.inode.fileType)
//    {
//        case BppleTextFileType:
//        {
//            NSString    *path = [NSString stringWithFormat:@"%@/%@", path, fileNode.inode.fileName];
//            NSData      *data = [self.bppleFileSystem read:filePath];
//            [fileManager createFileAtPath:path contents:data attributes:nil];
//            break;
//        }
//        case BppleDirectoryType:
//        {
//            break;
//        }
//    }
// }
@end
