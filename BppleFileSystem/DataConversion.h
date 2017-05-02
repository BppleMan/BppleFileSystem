//
//  DataConversion.h
//  FileSystem
//
//  Created by BppleMan on 17/4/15.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataConversion : NSObject

+ (NSMutableData *)NSUIntegerToData:(NSUInteger)value;

+ (NSUInteger)DataToNSUInteger:(NSMutableData *)data;

+ (NSUInteger)BytesToNSUInteger:(Byte *)buf;

+ (void)NSUIntegerToBytes:(Byte *)buf Value:(NSUInteger)value;
@end
