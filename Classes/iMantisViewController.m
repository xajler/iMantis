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
    
    [settings writeToFile:plistHelper.plistFileName atomically:YES];
    
    [settings release];
    
    [activityIndicator startAnimating];
    
    webService = [[NTWebService alloc]  initNTWebService];
    
    NSData *webData = [webService connectToWebService:@"mc_enum_status"];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData: webData];
    
    /*
    NSLog(@"DONE. Received Bytes: %d", [webData length]);
    
    NSString *theXML = [[NSString alloc] 
                        initWithBytes: [webData bytes] 
                        length:[webData length] 
                        encoding:NSUTF8StringEncoding];
    
    NSLog(theXML);
    [theXML release];   
    */
    
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities:YES];
    if ([xmlParser parse]) {
        //NSLog(@"parsed");
         [activityIndicator stopAnimating];  
        if ([webService isAuthenticated] == YES)
            NSLog(@"Nice");
        else
        {
            UIAlertView *alertError = [[UIAlertView alloc] initWithTitle: @"iMantis error" 
                                                                 message: @"Wrong credientals or problem connecting to Mantis server" 
                                                                delegate: self 
                                                       cancelButtonTitle: @"Ok" 
                                                       otherButtonTitles: nil];
            
            [alertError show];
            [alertError release];
        }
    }
    
    [webData release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
                                        namespaceURI:(NSString *)namespaceURI 
                                       qualifiedName:(NSString *)qualifiedName 
	                                      attributes:(NSDictionary *)attributeDict {
    
    if([elementName isEqualToString:@"faultcode"]) 
        webService.authenticated = NO;
	
	if([elementName isEqualToString:@"return"]) {
		//messageArray = [[NSMutableArray alloc] init];
        webService.authenticated = YES;
	}
	
	//NSLog(@"Processing Element: %@", elementName);
}

/*
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
	
	if(!currentElementValue) 
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if([elementName isEqualToString:@"return"])
		return;
	
	if([elementName isEqualToString:@"item"]) {
		[messageArray addObject:currentElementValue];
    //NSLog(@"Processing Value: %@", currentElementValue);
        
	}
	
	[currentElementValue release];
	currentElementValue = nil;
}
*/
 
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
	[super viewDidLoad];
}


- (void)dealloc {
    [super dealloc];
}

@end
