//
//  ViewController.m
//  NSDictionToObject
//
//  Created by wangyang on 11/5/14.
//  Copyright (c) 2014 WY. All rights reserved.
//

#import "ViewController.h"
#import "GMWikiSectionObject.h"
#import "GMWikiItemObject.h"
#import "NSDictionary+Object.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *sectionInfo =
    @{@"group_name": @"妙目含情",
      @"icon": @"http://xxxxx.cccc/abc.jpg",
      @"wiki": @[@{@"wiki_id": @3, @"wiki_name": @"abc"},
                 @{@"wiki_id": @4, @"wiki_name": @"adsf"}]
      };
    GMWikiSectionObject *section = [sectionInfo convertToObject:[GMWikiSectionObject class]
                                                     convertMap:@{@"wiki" : NSStringFromClass([GMWikiItemObject class])}];
    
    
    GMWikiSectionObject *section1 = [sectionInfo convertToObject:[GMWikiSectionObject class]];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
