//
//  AudioInputStream.h
//  AudioCast
//
//  Created by Milosz Derezynski on 21.05.17.
//  Copyright © 2017 Milosz Derezynski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioInputStream : NSInputStream

- (NSInteger)read:(uint8_t *_Nonnull)buffer
        maxLength:(NSUInteger)len;

- (BOOL)getBuffer:(uint8_t * _Nullable *_Nonnull)buffer
           length:(NSUInteger *_Nonnull)len;

@end
