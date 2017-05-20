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
    
    SSDPService *service = _services[row];
    
    if (tableColumn == tableView.tableColumns.firstObject) {
        cellView.textField.stringValue = service.serviceType;
    } else if (tableColumn == tableView.tableColumns.lastObject) {
        cellView.textField.stringValue = service.location.absoluteString;
    }
    return cellView;
}

#pragma mark - SSDP browser delegate methods

- (void) ssdpBrowser:(SSDPServiceBrowser *)browser didNotStartBrowsingForServices:(NSError *)error {
    NSLog(@"SSDP Browser got error: %@", error);
}

- (void) ssdpBrowser:(SSDPServiceBrowser *)browser didFindService:(SSDPService *)service {
    NSLog(@"SSDP Browser found: %@", service);

    if ([service.serviceType  isEqual: @"urn:schemas-upnp-org:device:MediaRenderer:1"]) {
    
        [_services insertObject:service atIndex:0];
        [self.table reloadData];
    }
}

- (void) ssdpBrowser:(SSDPServiceBrowser *)browser didRemoveService:(SSDPService *)service {
    NSLog(@"SSDP Browser removed: %@", service);
}


@end
