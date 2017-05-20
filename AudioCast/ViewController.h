//
//  ViewController.h
//  AudioCast
//
//  Created by Milosz Derezynski on 20.05.17.
//  Copyright © 2017 Milosz Derezynski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CocoaSSDP/SSDPService.h>
#import <CocoaSSDP/SSDPServiceBrowser.h>

@interface ViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, SSDPServiceBrowserDelegate>

@property (nonatomic, strong) IBOutlet NSTableView *table;

- (int)numberOfRowsInTableView:(NSTableView *)pTableViewObj;

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row;

@end
