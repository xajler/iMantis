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

@class iMantisAppDelegate;

@interface iMantisViewController : UIViewController {
    IBOutlet UITextField *usernameTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UITextField *mantisURLTextField;
    
    NTPListHelper *plistHelper;
    iMantisAppDelegate *appDelegate;
}

- (IBAction)login:(id)sender;

@end

