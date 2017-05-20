//
//  ACSSDPService.h
//  AudioCast
//
//  Created by Milosz Derezynski on 20.05.17.
//  Copyright © 2017 Milosz Derezynski. All rights reserved.
//

#import <CocoaSSDP/SSDPService.h>

@interface ACSSDPService : NSObject

@property(nonatomic) SSDPService * service;
@property(nonatomic,copy) NSString *friendlyName;
@property(nonatomic) NSData * imageData;

@end
