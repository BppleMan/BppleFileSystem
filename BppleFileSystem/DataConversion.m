//
//  DataConversion.m
//  FileSystem
//
//  Created by BppleMan on 17/4/15.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import "DataConversion.h"

@implementation DataConversion

+ (void)NSUIntegerToBytes:(Byte *)buf Value:(NSUInteger)value
{
    for (int i = 0; i < 8; i++)
    {
        buf[i] = (Byte)((value >> ((7 - i) * 8)) & 0xFF);
    }
}

+ (NSUInteger)BytesToNSUInteger:(Byte *)buf
{
    NSUInteger value = 0;
    
    for (int i = 0; i < 8; i++)
    {
        NSUInteger num = buf[i];
        value |= ((num & 0xFF) << ((7 - i) * 8));
    }
    return value;
}

+ (NSMutableData *)NSUIntegerToData:(NSUInteger)value
{
    Byte buf[sizeof(NSUInteger)];
    
    [DataConversion NSUIntegerToBytes:buf Value:value];
    
    NSMutableData *result = [NSMutableData dataWithBytes:buf length:sizeof(NSUInteger)];
    
    return result;
}

+ (NSUInteger)DataToNSUInteger:(NSMutableData *)data
{
    Byte buf[sizeof(NSUInteger)];
    
    [data getBytes:buf length:sizeof(NSUInteger)];
    
    NSUInteger result = [DataConversion BytesToNSUInteger:buf];
    
    return result;
}

@end
