//
//  PlistHelper.h
//  iMantis
//
//  Created by Kornelije Sajler on 10/4/10.
//  Copyright (c) 2010 Novatec. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PListHelper : NSObject {
    NSString *plistFileName;    

}

- (NSMutableDictionary *) getPListAsMutableDictionary:(NSString *) plistName;

@end
