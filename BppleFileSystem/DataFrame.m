//
//  DataFrame.m
//  BppleFileSystem
//
//  Created by BppleMan on 17/4/29.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import "DataFrame.h"

@implementation DataFrame

- (instancetype)initWithDataSize:(NSUInteger)dataSize ClusterSize:(NSUInteger)clusterSize
{
    self = [super init];
    if (self)
    {
        self.dataSource = [[NSMutableData alloc] initWithLength:dataSize];
        self.clusterSize = clusterSize;
        self.clusterCount = dataSize / clusterSize;
        self.visit = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < self.clusterCount; i++)
        {
            [self.visit addObject:[NSNumber numberWithBool:NO]];
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.dataSource = [coder decodeObjectForKey:@"dataSource"];
        self.visit = [coder decodeObjectForKey:@"visit"];
        self.clusterCount = [coder decodeIntegerForKey:@"clusterCount"];
        self.clusterSize = [coder decodeIntegerForKey:@"clusterSize"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.dataSource forKey:@"dataSource"];
    [coder encodeObject:self.visit forKey:@"visit"];
    [coder encodeInteger:self.clusterCount forKey:@"clusterCount"];
    [coder encodeInteger:self.clusterSize forKey:@"clusterSize"];
}

// 根据size返回相应簇的集合
- (NSMutableArray *)getFreeClusterPointWithSize:(NSUInteger)size
{
    NSUInteger needCount = size % self.clusterSize == 0 ? size / self.clusterSize : size / self.clusterSize + 1;
    return [self getFreeClusterPointWithCount:needCount];
}

// 根据数量返回相应簇的集合
- (NSMutableArray *)getFreeClusterPointWithCount:(NSUInteger)needCount
{
    NSMutableArray *clusterPoint = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < self.clusterCount; i++)
    {
        NSNumber *flag = self.visit[i];
        if (!flag.boolValue)
        {
            [self.visit replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
            [clusterPoint addObject:[NSNumber numberWithUnsignedInteger:i]];
            needCount--;
        }
        if (needCount == 0)
            break;
    }
    return clusterPoint;
}

- (void)writeDataWith:(NSData *)data WithFileNode:(FileNode *)fileNode
{
    //    计算需要占用几个簇
    NSUInteger need = data.length % self.clusterSize == 0 ? data.length / self.clusterSize : data.length / self.clusterSize + 1;
    //    获取已拥有的簇集合
    NSMutableArray *cluster = [fileNode.inode clusterPoint];
    //    计算还需要申请几个簇
    NSInteger count = need - cluster.count;
    
    /**
     *  如果count大于0则需要额外申请簇
     *   反之则应该释放多余的簇
     */
    if (count > 0)
        //    申请相应的空闲簇
        [cluster addObjectsFromArray:[self getFreeClusterPointWithCount:count]];
    else if (count < 0)
    {
        NSMutableArray *needFreeClusterPoint = [NSMutableArray arrayWithArray:[cluster subarrayWithRange:NSMakeRange(need, -count)]];
        [self free:needFreeClusterPoint];
        //        删除被释放的簇
        [cluster removeObjectsInArray:needFreeClusterPoint];
    }
    //    创建一个数组，里面存放的是：将data根据簇大小分成need个部分，每个部分大小必定是clusterSize，再将每个部分写入dataSource
    NSMutableArray  *datas = [[NSMutableArray alloc] init];
    NSUInteger      already = 0;
    for (NSUInteger i = 0; i < need; i++)
    {
        if (data.length - already < self.clusterSize)
            [datas addObject:[data subdataWithRange:NSMakeRange(i * self.clusterSize, data.length - already)]];
        else
        {
            [datas addObject:[data subdataWithRange:NSMakeRange(i * self.clusterSize, self.clusterSize)]];
            already += self.clusterSize;
        }
    }
    for (NSUInteger i = 0; i < need; i++)
    {
        NSData      *d = datas[i];
        const Byte  *buf;
        //        获取每一部份的data数据写入到buf
        buf = [d bytes];
        //        将buf覆盖到dataSource中，起点是第i个cluster的integer值*clusterSize，长度是单个clusterSize大小
        [self.dataSource replaceBytesInRange:NSMakeRange([cluster[i] unsignedIntegerValue] * self.clusterSize, d.length) withBytes:buf];
    }
}

- (NSMutableData *)readDataWithFileNode:(FileNode *)fileNode
{
    NSMutableData   *result = [[NSMutableData alloc] init];
    NSMutableArray  *clusterPoint = fileNode.inode.clusterPoint;
    NSUInteger      already = 0;
    for (NSNumber *num in clusterPoint)
    {
        if (fileNode.dataLength - already < self.clusterSize)
            [result appendData:[self.dataSource subdataWithRange:NSMakeRange([num unsignedIntegerValue] * self.clusterSize, fileNode.dataLength - already)]];
        else
        {
            [result appendData:[self.dataSource subdataWithRange:NSMakeRange([num unsignedIntegerValue] * self.clusterSize, self.clusterSize)]];
            already += self.clusterSize;
        }
    }
    return result;
}

- (void)free:(NSMutableArray *)clusterPoint
{
    for (NSNumber *point in clusterPoint)
    {
        [self.visit replaceObjectAtIndex:[point integerValue] withObject:[NSNumber numberWithBool:NO]];
    }
}

@end
