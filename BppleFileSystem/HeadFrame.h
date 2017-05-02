//
//  HeadFrame.h
//  FileSystem
//
//  Created by BppleMan on 17/4/15.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataConversion.h"

/**
 * 头部帧32个字节
 * 包括：
 *   12个字节为创建时间
 *   12个字节为最后一次修改时间
 *   8个字节为文件系统大小
 */
static const NSInteger headSize = 32;
@interface HeadFrame : NSObject <NSCoding>

//    创建时间yyMMddHHmmss 12字节
@property (nonatomic, strong)   NSDate *creatTime;

//    最后一次修改时间 yyMMddHHmmss 12字节
@property (nonatomic, strong)   NSDate *lastTime;

//    文件字节数 8字节
@property (nonatomic, assign)  NSInteger fileSize;

- (instancetype)initWithCreatTime:(NSDate *)creatTime lastTime:(NSDate *)lasthTime SIZE:(NSInteger)size;

+ (NSInteger)getHeadSize;

@end
