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

@interface FileSystemController : NSObject
{
    NSString *_path;
}

@property (atomic, strong) BppleFileSystem *bppleFileSystem;

- (instancetype)initWithFileSystemPath:(NSString *)path WithSize:(NSUInteger)size WithClusterSize:(NSUInteger)clusterSize;

- (void)creatBppleFileSystemWithSize:(NSUInteger)size WithClusterSize:(NSUInteger)clusterSize;

- (instancetype)initWithFileSystemPath:(NSString *)path;

- (void)saveFileSystem;

- (void)creatNewFolderWithPath:(BPath *)path;

- (NSMutableArray *)showFilesChildsWith:(BPath *)path;

- (void)creatNewTextFileWithPath:(BPath *)path;

- (void)removeFileWithPath:(BPath *)path;

- (void)writeTheTextFile:(BPath *)path With:(NSString *)stringValue;

- (NSString *)readTheTextFile:(BPath *)path;
@end
