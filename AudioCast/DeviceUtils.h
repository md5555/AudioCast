//
//  DeviceUtils.h
//  AudioCast
//
//  Created by Milosz Derezynski on 20.05.17.
//  Copyright © 2017 Milosz Derezynski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceUtils : NSObject

+ (NSString*) iconUrlFromDeviceXml:(NSURL*)url xmlDoc:(NSDictionary*)xmlDoc;

@end
