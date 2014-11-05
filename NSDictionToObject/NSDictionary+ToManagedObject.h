//
//  NSDictionary+ToManagedObject.h
//  yingshibaokaoyan
//
//  Created by wangyang on 6/6/14.
//  Copyright (c) 2014 com.zkyj.yingshibao.kaoyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSDictionary (ToManagedObject)

- (id)convertToManagedObject:(Class)someClass
      inManagedObjectContext:(NSManagedObjectContext *)context;

- (id)convertToManagedObject:(Class)someClass
      inManagedObjectContext:(NSManagedObjectContext *)context dateFormatIfNeed:(NSDateFormatter *)formatter;
@end
