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
#import "DeviceUtils.h"
#import "DeviceLoader.h"

@implementation ViewController

SSDPServiceBrowser *_browser;
NSMutableArray *_services;

- (void) viewDidLoad {
    
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    [self.table setDelegate:self];
    [self.table setDataSource:self];
    
    _services = [[NSMutableArray alloc] init];
    
    _browser = [[SSDPServiceBrowser alloc] initWithServiceType:SSDPServiceType_UPnP_MediaRenderer1];
    _browser.delegate = self;
    
    [_browser startBrowsingForServices];
}

#pragma mark - Table View

- (int) numberOfRowsInTableView:(NSTableView *)pTableViewObj {
    
    return (int) _services.count;
}

- (NSView *) tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    NSTableCellView *cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    ACSSDPService *service = _services[row];
    
    if (tableColumn == [tableView.tableColumns objectAtIndex:0]) {

        [cell.textField setStringValue:service.friendlyName];

        if (service.imageData != nil) {
            [cell.imageView setImage:[[NSImage alloc] initWithData:service.imageData]];
            [cell.imageView setHidden:NO];
        }
        
    } else if (tableColumn == [tableView.tableColumns objectAtIndex:1]) {
        
        [cell.textField setStringValue:service.service.location.absoluteString];
        [cell.imageView setHidden:YES];
    }
    
    return cell;
}

#pragma mark - Internal methods

- (void) deviceLoaded:(ACSSDPService*)service {
    
    [_services insertObject:service atIndex:0];
    [self.table reloadData];
}

#pragma mark - SSDP browser delegate methods

- (void) ssdpBrowser:(SSDPServiceBrowser *)browser didNotStartBrowsingForServices:(NSError *)error {
    NSLog(@"SSDP Browser got error: %@", error);
}

- (void) ssdpBrowser:(SSDPServiceBrowser *)browser didFindService:(SSDPService *)service {
    NSLog(@"SSDP Browser found: %@", service);
    
    DeviceLoader * loader = [[DeviceLoader alloc] initWithService:service];
    [loader setDelegate:self];
    [loader performLoad];
}

- (void) ssdpBrowser:(SSDPServiceBrowser *)browser didRemoveService:(SSDPService *)service {
    NSLog(@"SSDP Browser removed: %@", service);
}


@end
