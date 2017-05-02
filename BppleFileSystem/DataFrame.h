//
//  DataFrame.h
//  BppleFileSystem
//
//  Created by BppleMan on 17/4/29.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileNode.h"

@interface DataFrame : NSObject <NSCoding>

@property (strong) NSMutableArray *visit;

@property (strong) NSMutableData *dataSource;

@property (assign) NSUInteger clusterCount;

@property (assign) NSUInteger clusterSize;

- (instancetype)initWithDataSize:(NSUInteger)dataSize ClusterSize:(NSUInteger)clusterSize;

- (NSMutableArray *)getFreeClusterPointWithSize:(NSUInteger)size;

- (void)writeDataWith:(NSData *)data WithFileNode:(FileNode *)fileNode;

- (NSMutableData *)readDataWithFileNode:(FileNode *)fileNode;

- (void)free:(NSMutableArray *)clusterPoint;
@end
