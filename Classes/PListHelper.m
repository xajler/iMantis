//
//  PlistHelper.m
//  iMantis
//
//  Created by Kornelije Sajler on 10/4/10.
//  Copyright (c) 2010 Novatec. All rights reserved.
//

#import "PListHelper.h"


@implementation PListHelper

- (NSMutableDictionary *) getPListAsMutableDictionary:(NSString *) plistName
{
    plistFileName = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistFileName]) {
//        NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:plistFileName];
        
        NSMutableDictionary *settings = [settings mutableCopy];
        
       // [copyOfSettings setObject:@"k.sajler" forKey:@"Username"];
       // [copyOfSettings setObject:@"k.sajler" forKey:@"Password"];
        
       // for (id *key in copyOfSettings)
        //    NSLog(@"%@: %@", key, [copyOfSettings objectForKey:key]);
        
        [settings release];
    }
}
@end
