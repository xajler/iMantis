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


@synthesize window, viewController, messageArray, soapRequestMessage;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*
    if (soapRequestMessage != nil)
    {
        NTWebService *webService = [[NTWebService alloc]  initNTWebService];
        
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData: [webService connectToWebService:soapRequestMessage]];
        
        //Set delegate
        [xmlParser setDelegate:webService];
        
        //Start parsing the XML file.
        BOOL success = [xmlParser parse];
        
        if(success)
            NSLog(@"No Errors");
        else
            NSLog(@"Error Error Error!!!");
    }
*/
     
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

