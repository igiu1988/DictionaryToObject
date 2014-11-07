//
//  NSDictionary+Object.h
//  JsonConverter
//
//  Created by wangyang on 10/14/14.
//  Copyright (c) 2014 gengmei. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (Object)

/**
 *  将字典变为 object，去掉 key 里面的下划线，使用驼峰模式。
 *  value 是字典的话不做任何处理
 *
 */
- (id)convertToObject:(Class)someClass;

/**
 *  将字典变为 object，去掉 key 里面的下划线，使用驼峰模式。
 *  value 是字典的话将会依据 map 属性实例化，下面是一个 map 例子
 *  @code @{@"wiki" : @"GMWikiItemObject",
 @"wiki_section" : @"GMWikiSectionOjbect"}   @endcode
 *
 *  @param
 *      someClass   实例化类型
 *
 *  @param
 *      map         value 是字典时，相应 key 要变成的实体类型。
 *                  这个字典描述了 key 与对应类型的关系
 
 *  @return 转换好的数据
 */
- (id)convertToObject:(Class)someClass convertMap:(NSDictionary *)map;
@end
