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

@synthesize authenticated;

- (NTWebService *) initNTWebService {
    [super init];
    
    return self;
}

- (NSData *)connectToWebService:(NSString *) soapRequestMessage {
    
    plistHelper = [[NTPListHelper alloc] init];
    NSMutableDictionary *settings = [plistHelper getPListAsMutableDictionary:@"Settings"];
    NSMutableArray *soapParts = self.getSOAPMessageParts;
    
    NSString *soapMsg = [self setSOAPRequestMessage:soapRequestMessage withSOAPMessageParts:soapParts];
    [soapParts release];
    
	//---print it to the Debugger Console for verification---
    NSLog([NSString stringWithFormat:@"%@", soapMsg]);
	
    //NSURL *url = [NSURL URLWithString: @"http://localhost/mantis/api/soap/mantisconnect.php"];
	//NSURL *url = [NSURL URLWithString: @"http://systec.serveftp.net:8090/mantis/api/soap/mantisconnect.php"];
    
    NSString *urlPath = [[NSString alloc] initWithFormat:@"%@%@", [settings valueForKey:@"MantisUrl"],                                   
                         [settings valueForKey:@"MantisWebServicePath"]];
    
    NSURL *url = [NSURL URLWithString: urlPath];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
	
    //---set the various headers---
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //[req addValue:@"http://localhost/mantis/api/soap/mantisconnect.php/mc_project_get_categories" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:[NSString stringWithFormat:@"%@/@@", urlPath, soapRequestMessage] forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	
    //---set the HTTP method and body---
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
	
   // [activityIndicator startAnimating];
    NSError *error;
    NSURLResponse *response;
    //conn = [[NSURLConnection alloc] initWithRequest:req delegate: appDelegate startImmediately:YES];
    
    webData = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
        
    return webData;
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

- (void) connection:(NSURLConnection *) connection 
 didReceiveResponse:(NSURLResponse *) response {
    [webData setLength: 0];
}

- (void) connection:(NSURLConnection *) connection 
     didReceiveData:(NSData *) data {
    [webData appendData:data];
}

-(void) connection:(NSURLConnection *) connection 
  didFailWithError:(NSError *) error {
    //NSLog(error);
    [webData release];
    [connection release];
}

- (void) connectionDidFinishLoading:(NSURLConnection *) connection {
    NSLog(@"DONE. Received Bytes: %d", [webData length]);
    NSString *theXML = [[NSString alloc] 
                        initWithBytes: [webData mutableBytes] 
                        length:[webData length] 
                        encoding:NSUTF8StringEncoding];
    //---shows the XML---
    //[[self delegate] webServiceDidFinish];
    NSLog(theXML);
    [theXML release];    
	
   // [activityIndicator stopAnimating];    
    
	if (xmlParser) {
        [xmlParser release];
    }    
	
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
    
    [connection release];
    [webData release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
    
    if([elementName isEqualToString:@"faultcode"]) 
        authenticated = NO;
	
	if([elementName isEqualToString:@"return"]) {
		messageArray = [[NSMutableArray alloc] init];
        authenticated = YES;
	}
	
	//NSLog(@"Processing Element: %@", elementName);
}

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
        NSLog(@"Processing Value: %@", currentElementValue);
        
	}
	
	[currentElementValue release];
	currentElementValue = nil;
}
@end
