//
//  DeviceXmlLoader.m
//  AudioCast
//
//  Created by Milosz Derezynski on 20.05.17.
//  Copyright © 2017 Milosz Derezynski. All rights reserved.
//

#import "DeviceLoader.h"
#import "STHTTPRequest.h"
#import "ACSSDPService.h"
#import "XMLDictionary.h"
#import "DeviceUtils.h"

@implementation DeviceLoader

@synthesize delegate, baseService;

-(id)initWithService:(SSDPService*)service {
    
    self = [super init];
    self.baseService = service;
    return self;
}

- (void) performImageLoad:(NSURL*)deviceUrl xmlDoc:(NSDictionary*)xmlDoc service:(ACSSDPService*)service {
    
    NSString * iconUrl = [DeviceUtils iconUrlFromDeviceXml:deviceUrl xmlDoc:xmlDoc];
    
    if (iconUrl == nil) {
        [delegate deviceLoaded:service];
        return;
    }

    STHTTPRequest *imageRequest = [STHTTPRequest requestWithURLString:iconUrl];
    
    imageRequest.completionDataBlock = ^(NSDictionary *headers, NSData * data) {
        [service setImageData:data];
        [delegate deviceLoaded:service];
    };
    
    imageRequest.errorBlock = ^(NSError *error) {
        [delegate deviceLoaded:service];
    };
    
    [imageRequest startAsynchronous];
}

- (void) performLoad {
    
    NSURL * url = [NSURL URLWithString:baseService.location.absoluteString];
    
    STHTTPRequest *xmlRequest = [STHTTPRequest requestWithURLString:url.absoluteString];
    
    xmlRequest.completionBlock = ^(NSDictionary *headers, NSString *body) {
        
        NSDictionary  * xmlDoc  = [[XMLDictionaryParser alloc] dictionaryWithString:body];
        ACSSDPService * service = [[ACSSDPService alloc] init];
        
        service.service = baseService;
        service.friendlyName = [[xmlDoc valueForKeyPath:@"device.friendlyName"] innerText];
        
        [self performImageLoad:url xmlDoc:xmlDoc service:service];
    };
    
    xmlRequest.errorBlock = ^(NSError *error) {
        // probably nothing
    };
    
    [xmlRequest startAsynchronous];
}

@end
