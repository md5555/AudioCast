//
//  DeviceXmlLoader.h
//  AudioCast
//
//  Created by Milosz Derezynski on 20.05.17.
//  Copyright © 2017 Milosz Derezynski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACSSDPService.h"

@interface DeviceLoader : NSObject

-(id)initWithService:(SSDPService*)baseService;

-(void) performLoad;
-(void) performImageLoad:(NSURL*)deviceUrl xmlDoc:(NSDictionary*)xmlDoc service:(ACSSDPService*)service;

@property (nonatomic) id delegate;
@property (nonatomic) SSDPService * baseService;

@end

@interface NSObject(MyDelegateMethods)
- (void)deviceLoaded:(ACSSDPService *)acService;
@end
