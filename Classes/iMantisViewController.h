//
//  iMantisViewController.h
//  iMantis
//
//  Created by Kornelije Sajler on 9/30/10.
//  Copyright (c) 2010 Novatec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTPListHelper.h"
#import "NTWebService.h"


@interface iMantisViewController : UIViewController<NSXMLParserDelegate> {
    IBOutlet UITextField *usernameTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UITextField *mantisURLTextField;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
    NTPListHelper *plistHelper;
    NTWebService *webService;
    
    NSMutableString *currentElementValue;
    NSMutableArray *messageArray;
}

- (IBAction)login:(id)sender;

@end