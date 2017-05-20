//
//  AudioInputStream.m
//  AudioCast
//
//  Created by Milosz Derezynski on 21.05.17.
//  Copyright © 2017 Milosz Derezynski. All rights reserved.
//

#import "AudioInputStream.h"

@implementation AudioInputStream

- (NSInteger)read:(uint8_t *_Nonnull)buffer
        maxLength:(NSUInteger)len {

    return 0;
}

- (BOOL)getBuffer:(uint8_t * _Nullable *_Nonnull)buffer
           length:(NSUInteger *_Nonnull)len {
 
    return NO;
}

-(BOOL)getHasBytesAvailable
{
    return NO;
}

@end
