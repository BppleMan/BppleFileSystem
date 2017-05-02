//
//  FileSystem.h
//  FileSystem
//
//  Created by BppleMan on 17/4/15.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "HeadFrame.h"
#import "iNodeFrame.h"
#import "DataFrame.h"
#import "CataTree.h"
#import "iNode.h"
#import "BPath.h"

static const NSInteger DefaultFileSize = 1073741824;

@interface BppleFileSystem : NSObject <NSCoding>

@property (nonatomic, strong) HeadFrame *headFrame;

@property (nonatomic, strong) iNodeFrame *inodeFrame;

@property (nonatomic, strong) DataFrame *dataFrame;

@property (nonatomic, strong) CataTree *cataTree;

// @property (nonatomic, strong) NSMutableData *data;

- (instancetype)initWithFileSize:(NSUInteger)fileSize WithClusterSize:(NSUInteger)clusterSize;

- (FileNode *)cd:(BPath *)path;

- (FileNode *)ls:(BPath *)path;

- (void)mkdir:(BPath *)path;

- (void)rm:(BPath *)path;

- (void)vim:(BPath *)path;

- (void)write:(BPath *)path with:(NSData *)data;

- (NSData *)read:(BPath *)path;

+ (NSInteger)getDefaultFileSize;

@end
