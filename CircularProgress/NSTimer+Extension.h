//
//  NSTimer+Extension.h
//  NSTimer+Extension
//
//  Created by Hari Krishna  on 20/07/16.
//  Copyright © 2016 VrindaTechApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Extension)

+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
+ (id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

- (void)pauseTimer;
- (void)resumeTimer;

@end