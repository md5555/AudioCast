//
//  DeviceUtils.m
//  AudioCast
//
//  Created by Milosz Derezynski on 20.05.17.
//  Copyright © 2017 Milosz Derezynski. All rights reserved.
//

#import "DeviceUtils.h"
#import "XMLDictionary.h"

@implementation DeviceUtils

+ (NSString*) iconUrlFromDeviceXml:(NSURL*) url xmlDoc:(NSDictionary*) xmlDoc {
    
    NSMutableString * imageUrlString = [NSMutableString string];
    
    NSArray * array = [xmlDoc valueForKeyPath:@"device.iconList.icon"];
    
    NSString * iconUrl = [[[array objectAtIndex:0] valueForKey:@"url"] innerText];
    
    NSLog(@"IMG: iconUrl: %@", iconUrl);
    
    if (iconUrl == nil) {
        return nil;
    }
    
    [imageUrlString appendString:@"http://"];
    [imageUrlString appendString:url.host];
    [imageUrlString appendFormat:@":%@", url.port];
    [imageUrlString appendString:iconUrl];

    return imageUrlString;
}

@end
