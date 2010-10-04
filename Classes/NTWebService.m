//
//  NTWebServiceHelper.m
//  iMantis
//
//  Created by Kornelije Sajler on 10/4/10.
//  Copyright (c) 2010 Novatec. All rights reserved.
//

#import "NTWebService.h"
#import "NTSOAPPart.h"
#import "iMantisAppDelegate.h"

@implementation NTWebService

- (NTWebService *) initNTWebService {
    [super init];
    
    appDelegate = (iMantisAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return self;
}

- (NSMutableData *)connectToWebService:(NSString *) soapRequestMessage {
    
    plistHelper = [[NTPListHelper alloc] init];
    NSMutableDictionary *settings = [plistHelper getPListAsMutableDictionary:@"Settings"];
    NSMutableArray *soapParts = self.getSOAPMessageParts;
    
    NSString *soapMsg = [self setSOAPRequestMessage:soapRequestMessage withSOAPMessageParts:soapParts];
    [soapParts release];
    
	//---print it to the Debugger Console for verification---
    NSLog(soapMsg);
	
    //NSURL *url = [NSURL URLWithString: @"http://localhost/mantis/api/soap/mantisconnect.php"];
	//NSURL *url = [NSURL URLWithString: @"http://systec.serveftp.net:8090/mantis/api/soap/mantisconnect.php"];
    
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", 
                                       [settings valueForKey:@"MantisUrl"],                                        
                                       [settings valueForKey:@"MantisWebServicePath"] ]];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
	
    //---set the various headers---
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //[req addValue:@"http://localhost/mantis/api/soap/mantisconnect.php/mc_project_get_categories" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:@"http://systec.serveftp.net:8090/mantis/api/soap/mantisconnect.php/mc_project_get_categories" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	
    //---set the HTTP method and body---
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
	
   // [activityIndicator startAnimating];
    
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [[NSMutableData data] retain];
        //NSLog(webData);
        return webData;
    }
    
    return nil;
}

- (NSString *)setSOAPRequestMessage:(NSString *)nameService 
               withSOAPMessageParts:(NSMutableArray *)messageParts
{
    NSMutableString *soapMessageParts  = [[[NSMutableString alloc] init] autorelease];
    
    for (NTSOAPPart *p in messageParts)
    {
        NSString *partString = [NSString stringWithFormat:@"<%@ xsi:type=\"xsd:%@\">%@</%@> ", 
                                                    p.name, p.type, p.value, p.name];
        [soapMessageParts appendString: partString];
    }
    
    return [NSString stringWithFormat:
            @"<?xml version=\"1.0\" encoding=\"utf-8\"?> "
            "<soap:Envelope " 
            "xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" " 
            "xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" "
            "xmlns:tns=\"http://futureware.biz/mantisconnect\" " 
            "xmlns:types=\"http://futureware.biz/mantisconnect/encodedTypes\" " 
            "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "  
            "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"> " 
            "<soap:Body soap:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"> "
            "<tns:%@> "
            "%@ "
            "</tns:%@> "
            "</soap:Body> "
            "</soap:Envelope>", nameService, soapMessageParts, nameService ];
}

- (NSMutableArray *) getSOAPMessageParts
{
    NSMutableArray *soapParts = [[NSMutableArray alloc] init];
    plistHelper = [[NTPListHelper alloc] init];
    NSMutableDictionary *settings = [plistHelper getPListAsMutableDictionary:@"Settings"];
    
    part = [[NTSOAPPart alloc] init];
    part.name = @"username";
    part.type = @"string";
    part.value = [settings objectForKey:@"Username"];
    
    [soapParts addObject:part];
    [part release];
    
    part = [[NTSOAPPart alloc] init];
    part.name = @"password";
    part.type = @"string";
    part.value = [settings objectForKey:@"Password"];;    
    
    [soapParts addObject:part];
    [settings release];
    [part release];
    
    return soapParts;
}

@end
