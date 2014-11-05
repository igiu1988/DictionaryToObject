//
//  NSDictionary+ToManagedObject.m
//  yingshibaokaoyan
//
//  Created by wangyang on 6/6/14.
//  Copyright (c) 2014 com.zkyj.yingshibao.kaoyao. All rights reserved.
//

#import "NSDictionary+ToManagedObject.h"
#import <objc/runtime.h>


@implementation NSDictionary (ToManagedObject)
- (id)convertToManagedObject:(Class)someClass
      inManagedObjectContext:(NSManagedObjectContext *)context
{
    return [self convertToManagedObject:someClass inManagedObjectContext:context dateFormatIfNeed:nil];
}
/**
 *  分析Class的每个属性及对应的数据类型，将JSON里的key-value正确对应到Class的属性，并插入到数据库
 *
 *  @param someClass 将要生成的Core Data模型（Managed Object）
 *  @param context   NSManagedObjectContext的context
 *
 *  @return 生成的NSManagedObject实体
 */
- (id)convertToManagedObject:(Class)someClass inManagedObjectContext:(NSManagedObjectContext *)context dateFormatIfNeed:(NSDateFormatter *)formatter
{
    // 将要在表中插入的实体
    NSEntityDescription *object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(someClass) inManagedObjectContext:context];
    
    // 取出所有的属性数组，及属性的个数
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList(someClass, &propertyCount);

    // 循环这些属性
    for (int i = 0; i<propertyCount; i++) {
        
        // 属性名
        NSString *property = [NSString stringWithCString:property_getName(propertys[i]) encoding:NSUTF8StringEncoding];
        
        // 属性的数据类型
        const char *attri = property_getAttributes(propertys[i]);
        NSString* propertyAttribute = [NSString stringWithUTF8String:attri];
//        NSLog(@"class: %@, property: %@, propertyAttribut: %@",NSStringFromClass(someClass), property, propertyAttribute);
        
        // 根据属性的数据类型，做不同的操作
        // 如果是NSOrderedSet或者NSSet就做成Relationship，所以会有递归
        if ([propertyAttribute hasPrefix:@"T@\"NSOrderedSet"] || [propertyAttribute hasPrefix:@"T@\"NSSet"]) {
            
            NSArray *array = self[property];
            // NSArray下面的每一个元素肯定都是某个相同表下的一条记录，并且这个元素肯定是NSDictionary的
            
            // 取得这个表（类）名
            NSString *firstCapChar = [[property substringToIndex:1] capitalizedString];
            NSString *cappedClassString = [property stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
            
            NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSet];

            for (int j = 0; j < array.count; j++) {
                NSDictionary *element = array[j];
                id object = [element convertToManagedObject:NSClassFromString(cappedClassString) inManagedObjectContext:context];
                [set addObject:object];
            }
            
            [object setValue:set forKey:property];
            
        }else if ([propertyAttribute hasPrefix:@"T@\"NSDate"] && formatter)
        {
            NSDate *date = [formatter dateFromString:self[property]];
            [object setValue:date forKey:property];
        }else{
            
            [object setValue:self[property] forKey:property];

        }

    }
    
    return object;
}


@end
