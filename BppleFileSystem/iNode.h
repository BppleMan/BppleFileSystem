//
//  iNode.h
//  FileSystem
//
//  Created by BppleMan on 17/4/15.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iNode : NSObject <NSCoding>
typedef NS_ENUM (NSUInteger, FileType)
{
    BppleDirectoryType = 0,
    BppleTextFileType = 1
};
//    文件名称
@property (nonatomic, strong) NSString *fileName;

//    文件拥有者
@property (nonatomic, assign)   NSString *userID;

//    指向文件的所有簇的指针集合 用NSNumber存储 表示簇的位置
@property (strong) NSMutableArray *clusterPoint;

//    文件类型
@property (assign) FileType fileType;

//    是否占用
@property (nonatomic, assign)  BOOL used;

//    iNode ID
@property (nonatomic, assign)    NSUInteger inodeID;

- (instancetype)initWithID:(NSUInteger)ID;

@end
