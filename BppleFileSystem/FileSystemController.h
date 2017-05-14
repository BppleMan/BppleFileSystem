//
//  FileSystemController.h
//  FileSystem
//
//  Created by BppleMan on 17/4/15.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "BppleFileSystem.h"
#import "NSFileManager+DirectoryLocations.h"

typedef enum : NSUInteger
{
    SUCCESS,
    SAMENAME,
    FAILED,
} FileAction;
@interface FileSystemController : NSObject
{
    NSString *_path;
}

@property (atomic, strong) BppleFileSystem *bppleFileSystem;

- (instancetype)initWithFileSystemPath:(NSString *)path WithSize:(NSUInteger)size WithClusterSize:(NSUInteger)clusterSize;

- (void)creatBppleFileSystemWithSize:(NSUInteger)size WithClusterSize:(NSUInteger)clusterSize;

- (instancetype)initWithFileSystemPath:(NSString *)path;

- (void)saveFileSystem;

- (FileAction)creatNewFolderWithPath:(BPath *)path;

- (NSMutableArray <FileNode *> *)showFileChildsWith:(BPath *)path;

- (FileAction)creatNewTextFileWithPath:(BPath *)path;

- (void)removeFileWithPath:(BPath *)path;

- (void)writeTheTextFile:(BPath *)path With:(NSString *)stringValue;

- (FileAction)renameFileWith:(BPath *)path WithNewName:(NSString *)newName;

- (FileAction)transferFileWithStringPath:(NSString *)stringPath IntoFileSystemWithBPath:(BPath *)filePath;

- (FileAction)cloneFileWithOldPath:(BPath *)oldPath IntoNewPath:(BPath *)newPath;

- (NSString *)readTheTextFile:(BPath *)path;

- (NSString *)creatFileInRealSystemWithPath:(BPath *)filePath;

@end
