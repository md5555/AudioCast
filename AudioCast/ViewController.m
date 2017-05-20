//
//  ViewController.m
//  AudioCast
//
//  Created by Milosz Derezynski on 20.05.17.
//  Copyright © 2017 Milosz Derezynski. All rights reserved.
//

#import "ViewController.h"
#import <CocoaSSDP/SSDPService.h>
#import <CocoaSSDP/SSDPServiceTypes.h>
#import "STHTTPRequest.h"
#import "ACSSDPService.h"
#import "XMLDictionary.h"

@implementation ViewController

SSDPServiceBrowser *_browser;
NSMutableArray *_services;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    [self.table setDelegate:self];
    [self.table setDataSource:self];
    
    _services = [[NSMutableArray alloc] init];
    
    _browser = [[SSDPServiceBrowser alloc] initWithServiceType:SSDPServiceType_All];
    _browser.delegate = self;
    
    [_browser startBrowsingForServices];
}

#pragma mark - Table View

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
    
}

- (int)numberOfRowsInTableView:(NSTableView *)pTableViewObj {
    
    return (int)_services.count;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    ACSSDPService *service = _services[row];
    
    if (tableColumn == tableView.tableColumns.firstObject) {

        cellView.textField.stringValue = service.friendlyName;

        if (service.imageData != nil) {
            
            NSLog(@"IMG: setting image to cell");
            
            NSImage * image = [[NSImage alloc] initWithData:(NSData *)service.imageData];
            [cellView.imageView setImage:image];
            cellView.imageView.hidden = NO;
        }
        
    } else if (tableColumn == tableView.tableColumns.lastObject) {
        
        cellView.textField.stringValue = service.service.location.absoluteString;
        cellView.imageView.hidden = YES;
    }
    
    return cellView;
}

#pragma mark - Internal methods

- (void) loadDeviceXml:(SSDPService*)baseService {
    
    STHTTPRequest *xmlRequest = [STHTTPRequest requestWithURLString:baseService.location.absoluteString];
    xmlRequest.completionBlock = ^(NSDictionary *headers, NSString *body) {
        
        NSDictionary  * xmlDoc  = [[XMLDictionaryParser alloc] dictionaryWithString:body];
        ACSSDPService * service = [[ACSSDPService alloc] init];
        
        service.service = baseService;
        service.friendlyName = [[xmlDoc valueForKeyPath:@"device.friendlyName"] innerText];
        
        NSURL * url = [NSURL URLWithString:service.service.location.absoluteString];
        
        NSMutableString * imageUrlString = [NSMutableString string];
        
        NSArray * array = [xmlDoc valueForKeyPath:@"device.iconList.icon"];

        NSString * iconUrl = [[[array objectAtIndex:0] valueForKey:@"url"] innerText];
        
        NSLog(@"IMG: iconUrl: %@", iconUrl);

        if (iconUrl == nil) {
            [service setImageData:nil];
            [_services insertObject:service atIndex:0];
            [self.table reloadData];
            return;
        }
        
        [imageUrlString appendString:@"http://"];
        [imageUrlString appendString:url.host];
        [imageUrlString appendFormat:@":%@", url.port];
        [imageUrlString appendString:iconUrl];
        
        NSLog(@"IMG: FullURL: %@", imageUrlString);
        
        STHTTPRequest *imageRequest = [STHTTPRequest requestWithURLString:imageUrlString];
        
        imageRequest.completionDataBlock = ^(NSDictionary *headers, NSData * data) {
          
            [service setImageData:data];
            
            NSLog(@"IMG: ImageLoadSuccess: %@", imageUrlString);

            [_services insertObject:service atIndex:0];
            [self.table reloadData];
        };
        
        imageRequest.errorBlock = ^(NSError *error) {
            // TBD
        };
        
        [imageRequest startAsynchronous];
    };
    
    xmlRequest.errorBlock = ^(NSError *error) {
        // TBD
    };

    [xmlRequest startAsynchronous];
    
}

#pragma mark - SSDP browser delegate methods

- (void) ssdpBrowser:(SSDPServiceBrowser *)browser didNotStartBrowsingForServices:(NSError *)error {
    NSLog(@"SSDP Browser got error: %@", error);
}

- (void) ssdpBrowser:(SSDPServiceBrowser *)browser didFindService:(SSDPService *)service {
    NSLog(@"SSDP Browser found: %@", service);

    if ([service.serviceType  isEqual: @"urn:schemas-upnp-org:device:MediaRenderer:1"]) {
        
        [self loadDeviceXml:service];
    }
}

- (void) ssdpBrowser:(SSDPServiceBrowser *)browser didRemoveService:(SSDPService *)service {
    NSLog(@"SSDP Browser removed: %@", service);
}


@end
