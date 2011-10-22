//
//  NTSOAPParts.h
//  iMantis
//
//  Created by Kornelije Sajler on 9/26/10.
//  Copyright (c) 2010 MetaIntellect. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NTSOAPPart : NSObject {
    NSString *name;
    NSString *type;
    NSString *value;
}

@property (nonatomic, retain) NSString *name, *type, *value;

@end
