//
//  iMantisAppDelegate.m
//  iMantis
//
//  Created by Kornelije Sajler on 9/30/10.
//  Copyright (c) 2010 Novatec. All rights reserved.
//


#import "iMantisAppDelegate.h"
#import "iMantisViewController.h"
#import "NTWebService.h"

@implementation iMantisAppDelegate


@synthesize window, viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {

    // Save data if appropriate.
}

- (void)dealloc {

    [window release];
    [viewController release];
    [super dealloc];
}

@end

