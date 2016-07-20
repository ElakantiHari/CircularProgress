//
//  CPProgressTimer.h
//  CircularProgress
//
//  Created by Hari Krishna  on 20/07/16.
//  Copyright © 2016 VrindaTechApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CPProgressTimerDelegate;

typedef CGFloat (^CPProgressBlock)();

@interface CPProgressTimer : UIView

@property(nonatomic, weak) id <CPProgressTimerDelegate> delegate;

@property(nonatomic) CGFloat frameWidth;
@property(nonatomic, strong) UIColor *progressColor;
@property(nonatomic, strong) UIColor *progressBorderColor;
@property(nonatomic, strong) UIColor *progrtssCircleColor;

- (void)startWithBlock:(CPProgressBlock)block withTimeInterval:(int)timedDuration;
- (void)stop;
- (void)resume;
- (void)pause;
- (void)invalidateBackgroundTimer;
- (void)setTimeLabelWithDuration:(int)lTimeDuration;

@end

@protocol CPProgressTimerDelegate <NSObject>
@optional
- (void)willUpdateProgressTimer:(CPProgressTimer *)progressTimer percentage:(CGFloat)percentage;
- (void)didUpdateProgressTimer:(CPProgressTimer *)progressTimer percentage:(CGFloat)percentage;
- (void)didStopProgressTimer:(CPProgressTimer *)progressTimer percentage:(CGFloat)percentage;
@end
