//
//  iMantisAppDelegate.h
//  iMantis
//
//  Created by Kornelije Sajler on 9/30/10.
//  Copyright (c) 2010 Novatec. All rights reserved.
//


#import <UIKit/UIKit.h>

@class iMantisViewController;

@interface iMantisAppDelegate : NSObject <UIApplicationDelegate> {

    UIWindow *window;
    iMantisViewController *viewController;
    
    NSMutableArray *messageArray;
    NSString *soapRequestMessage;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iMantisViewController *viewController;
@property (nonatomic, retain) NSMutableArray *messageArray;
@property (nonatomic, retain) NSString *soapRequestMessage;

@end

