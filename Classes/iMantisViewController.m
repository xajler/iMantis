//
//  iMantisViewController.m
//  iMantis
//
//  Created by Kornelije Sajler on 9/30/10.
//  Copyright (c) 2010 Novatec. All rights reserved.
//

#import "iMantisViewController.h"
#import "iMantisAppDelegate.h"

@implementation iMantisViewController

- (IBAction)login:(id)sender
{
    plistHelper = [[NTPListHelper alloc] init];
    NSMutableDictionary *settings = [plistHelper getPListAsMutableDictionary:@"Settings"];
    
    [settings setObject:usernameTextField.text forKey:@"Username"];
    [settings setObject:passwordTextField.text forKey:@"Password"];
    [settings setObject:mantisURLTextField.text forKey:@"MantisUrl"];      
    
    [settings release];
    
    NTWebService *webService = [[NTWebService alloc]  initNTWebService];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData: [webService connectToWebService:@"mc_enum_status"]];
    
    //Set delegate
    [xmlParser setDelegate:webService];
    
    //Start parsing the XML file.
    BOOL success = [xmlParser parse];
    
    if(success)
        NSLog(@"No Errors");
    else
        NSLog(@"Error Error Error!!!");
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	appDelegate = (iMantisAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
}


- (void)dealloc {
    [super dealloc];
}

@end
