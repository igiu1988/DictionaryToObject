//
//  NSDictionary+Object.m
//  JsonConverter
//
//  Created by wangyang on 10/14/14.
//  Copyright (c) 2014 gengmei. All rights reserved.
//

#import "NSDictionary+Object.h"
#import <objc/runtime.h>

@implementation NSDictionary (Object)
- (id)convertToObject:(Class)someClass
{
    return [self convertToObject:someClass convertMap:nil];
}


- (id)convertToObject:(Class)someClass convertMap:(NSDictionary *)map
{
    // 将要在表中插入的实体
    id object = [someClass new];
    
    NSArray *allKeys = [self allKeys];
    
    // 循环这些属性
    for (int i = 0; i<allKeys.count; i++) {
        
        // 属性名
        NSString *dicKey = allKeys[i];
        NSString *objectKey = dicKey;
        if ([dicKey rangeOfString:@"_"].length > 0) {
            NSArray *propertySplit = [dicKey componentsSeparatedByString:@"_"];
            NSMutableString *camelPropertyString = [NSMutableString string];
            [camelPropertyString appendString:propertySplit[0]];
            
            for (int i = 1; i<propertySplit.count; i++) {
                NSString *temp = [propertySplit[i] capitalizedStringWithLocale:[NSLocale currentLocale]];
                [camelPropertyString appendString:temp];
            }
            
            objectKey = camelPropertyString;
        }
        
        [self setValue:self[dicKey] forKey:objectKey map:map instance:object];
        
    }
    
    return object;
}

- (void)setValue:(id)value forKey:(NSString *)key map:(NSDictionary *)map instance:(id)object
{
    id finalValue = value;
    
    if ([value isKindOfClass:[NSArray class]] && map && map.allKeys.count != 0) {
        
        // 可变数组用来存放将要生成的实体
        NSMutableArray *mutableArray = [NSMutableArray array];
        
        // 1. 通过 key 找到 map 里对应的 class
        Class class = NSClassFromString(map[key]);
        
        // 2. 循环 array，实例化所有的 class
        NSArray *valueArray = value;
        for (int i = 0; i < valueArray.count; i++) {
            id object = [valueArray[i] convertToObject:class convertMap:map];
            [mutableArray addObject:object];
        }
        
        // 得到最终的 value
        finalValue = mutableArray;
        
    }
    
    [object setValue:finalValue forKey:key];
}
@end
