//
//  HKProgressTimer.h
//  CircularProgress
//
//  Created by HariKrishna  on 20/07/16.
//  Copyright © 2016 Apptitude. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HKProgressTimerDelegate;

typedef CGFloat (^HKProgressBlock)();

@interface HKProgressTimer : UIView

@property(nonatomic, weak) id <HKProgressTimerDelegate> delegate;

typedef NS_ENUM(NSInteger, ProgressDirection) {
    ProgressDirectionFillClockwise,
    ProgressDirectionFillAntiClockwise,
    ProgressDirectionUnFillClockwise,
    ProgressDirectionUnFillAntiClockwise,
};

@property(nonatomic, weak) UIColor *progressColor;
@property(nonatomic, weak) UIColor *progressBorderColor;
@property(nonatomic, weak) UIColor *progressCircleColor;
@property(nonatomic) CGFloat frameWidth;
@property(nonatomic) ProgressDirection progressDirection;

- (void)startWithBlock:(HKProgressBlock)block withTimeInterval:(int)timedDuration;
- (void)stop;
- (void)resume;
- (void)pause;
- (void)invalidateBackgroundTimer;
- (void)setTimeLabelWithDuration:(int)lTimeDuration;

@end

@protocol HKProgressTimerDelegate <NSObject>
@optional
- (void)willUpdateProgressTimer:(HKProgressTimer *)progressTimer percentage:(CGFloat)percentage;
- (void)didUpdateProgressTimer:(HKProgressTimer *)progressTimer percentage:(CGFloat)percentage;
- (void)didStopProgressTimer:(HKProgressTimer *)progressTimer percentage:(CGFloat)percentage;
@end
