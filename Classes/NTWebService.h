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

@interface NTWebService : NSObject <NSXMLParserDelegate> {
    iMantisAppDelegate *appDelegate;
    
    NSData *webData;
    NSMutableString *currentElementValue;
    NSURLConnection *conn;
	
    NTSOAPPart *part;
    NTPListHelper *plistHelper;
    NSXMLParser *xmlParser;
    
    NSMutableArray *messageArray;
    
    BOOL isAuthenticated;
}

@property (getter=isAuthenticated) BOOL authenticated;

- (NTWebService *) initNTWebService;

- (NSString *)setSOAPRequestMessage:(NSString *)nameService 
               withSOAPMessageParts:(NSMutableArray *)messageParts;

- (NSData *)connectToWebService:(NSString *) soapRequestMessage;

- (NSMutableArray *) getSOAPMessageParts;
@end