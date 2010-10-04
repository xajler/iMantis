//
//  NTWebServiceHelper.h
//  iMantis
//
//  Created by Kornelije Sajler on 10/4/10.
//  Copyright (c) 2010 Novatec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTSOAPPart.h"
#import "NTPListHelper.h"

@class iMantisAppDelegate, NTSOAPPart;

@interface NTWebService : NSObject {
    iMantisAppDelegate *appDelegate;
    
    NSMutableData *webData;
    NSMutableString *currentElementValue;
    NSURLConnection *conn;
	
    NTSOAPPart *part;
    NTPListHelper *plistHelper;
	NSMutableArray *messageArray;
}

- (NTWebService *) initNTWebService;

- (NSString *)setSOAPRequestMessage:(NSString *)nameService 
               withSOAPMessageParts:(NSMutableArray *)messageParts;

- (NSMutableData *)connectToWebService:(NSString *) soapRequestMessage;

- (NSMutableArray *) getSOAPMessageParts;
@end