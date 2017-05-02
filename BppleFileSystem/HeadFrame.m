//
//  HeadFrame.m
//  FileSystem
//
//  Created by BppleMan on 17/4/15.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import "HeadFrame.h"

@implementation HeadFrame

- (instancetype)initWithCreatTime:(NSDate *)creatTime lastTime:(NSDate *)lasthTime SIZE:(NSInteger)size
{
    self = [super init];
    if (self)
    {
        self.creatTime = creatTime;
        self.lastTime = lasthTime;
        self.fileSize = size;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.creatTime = [coder decodeObjectForKey:@"creatTime"];
        self.lastTime = [coder decodeObjectForKey:@"lastTime"];
        self.fileSize = [coder decodeIntegerForKey:@"fileSize"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.creatTime forKey:@"creatTime"];
    [coder encodeObject:self.lastTime forKey:@"lastTime"];
    [coder encodeInteger:self.fileSize forKey:@"fileSize"];
}

// - (instancetype)initWithData:(NSMutableData *)data
// {
//    self = [super init];
//    if (self)
//    {
//        _data = data;
//        NSData  *creatTimeData = [_data subdataWithRange:NSMakeRange(0, 12)];
//        NSData  *lastTimeData = [_data subdataWithRange:NSMakeRange(12, 12)];
//        NSData  *sizeData = [_data subdataWithRange:NSMakeRange(24, 8)];
//
//        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
//        [dateFormat setDateFormat:@"yyMMddHHmmss"];
//
//        _creatTime = [dateFormat dateFromString:[[NSString alloc]initWithData:creatTimeData encoding:NSUTF8StringEncoding]];
//        _lastTime = [dateFormat dateFromString:[[NSString alloc]initWithData:lastTimeData encoding:NSUTF8StringEncoding]];
//        _fileSize = [DataConversion NSDataToNSInteger:sizeData];
//    }
//    return self;
// }

- (NSString *)description
{
    NSString *value = [NSString stringWithFormat:@"\n{\n\t创建时间：%@\n\t最后一次修改时间：%@\n\t文件大小(Byte)：%ld\n}", _creatTime, _lastTime, _fileSize];
    
    return value;
}

+ (NSInteger)getHeadSize
{
    return headSize;
}

@end
