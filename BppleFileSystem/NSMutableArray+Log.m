//
//  NSMutableArray+Log.m
//  BppleFileSystem
//
//  Created by BppleMan on 17/5/8.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import "NSMutableArray+Log.h"

@implementation NSMutableArray (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *result = [[NSMutableString alloc] initWithString:@"(\n"];
    for (id obj in self)
    {
        [result appendFormat:@"\t\"%@\",\n", obj];
    }
    [result appendString:@")"];
    return result;
}

@end
