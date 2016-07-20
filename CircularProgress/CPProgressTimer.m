//
//  CPProgressTimer.m
//  CircularProgress
//
//  Created by Hari Krishna  on 20/07/16.
//  Copyright © 2016 VrindaTechApps. All rights reserved.
//

#import "CPProgressTimer.h"
//#import "NSTimer+Extension.h"

#define UIColorMake(r, g, b, a) [UIColor colorWithRed:r / 255. green:g / 255. blue:b / 255. alpha:a]


@interface CPProgressTimer ()

@property(nonatomic) CGFloat progress;
@property(nonatomic) CGFloat floatSecond;
@property(nonatomic) int timeDuration;
@property(nonatomic) int ticks;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, copy) CPProgressBlock block;
@property(nonatomic, strong) UILabel *timerLabel;

@end

@implementation CPProgressTimer

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupParams];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupParams];
    }
    return self;
}

- (void)setupParams {
    
    self.backgroundColor = [UIColor clearColor];
    
    self.frameWidth = 10;
    
    self.progressColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    self.progressBackgroundColor = [UIColor clearColor];
    self.circleBackgroundColor = [UIColor clearColor];
    
    self.progress = 0;
    
    self.timerLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.timerLabel.textAlignment = NSTextAlignmentCenter;
    self.timerLabel.font = [UIFont boldSystemFontOfSize:25.0f];
    [self addSubview:self.timerLabel];
    
    self.timerLabel.text = @"00:00";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"PRACTICE_TIME"]) {
        int timeduration = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PRACTICE_TIME"] intValue];
        [self setTimeLabelWithDuration:timeduration];
    }
}

- (void)setTimeLabelWithDuration:(int)lTimeDuration {
    int seconds = lTimeDuration % 60;
    int minutes = (lTimeDuration / 60) % 60;
    int hours = lTimeDuration / 3600;
    if (hours>0) {
        self.timerLabel.text = [NSString stringWithFormat:@"%01d:%02d:%02d", hours,minutes, seconds];;
    } else {
        self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];;
    }
}


- (void)startWithBlock:(CPProgressBlock)block withTimeInterval:(int)timedDuration{
    NSAssert(block, @"Can't start progress without progressBlock");
    self.floatSecond = 1.0;
    self.timeDuration = timedDuration;
    [self setTimeLabelWithDuration:self.timeDuration];
    
    self.block = block;
    if (!self.timer.isValid) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f block:^{
            [self updateProgress];
        } repeats:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            [[NSRunLoop currentRunLoop] run];
        });
    }
}

- (void)invalidateBackgroundTimer {
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
}

- (void)resume {
    if (self.timer.isValid) {
        [self.timer resumeTimer];
    }
}

- (void)pause {
    if (self.timer.isValid) {
        [self.timer pauseTimer];
    }
}

- (void)updateProgress {
    if ([self.delegate respondsToSelector:@selector(willUpdateProgressTimer:percentage:)]) {
        if (self.floatSecond <= 0.2 ) {
            self.floatSecond = 1.0;
            self.timeDuration--;
            [self setTimeLabelWithDuration:self.timeDuration];
        } else {
            self.floatSecond -= 0.1;
        }
        [self.delegate willUpdateProgressTimer:self percentage:self.progress];
    }
    self.progress = self.block();
    [self setNeedsDisplay];
    if ([self.delegate respondsToSelector:@selector(didUpdateProgressTimer:percentage:)]) {
        if (self.progress == 1.0) {
            [self.timer invalidate];
        }
        [self.delegate didUpdateProgressTimer:self percentage:self.progress];
    }
}

- (void)stop {
    [self.timer invalidate];
    if ([self.delegate respondsToSelector:@selector(didStopProgressTimer:percentage:)]) {
        [self.delegate didStopProgressTimer:self percentage:self.progress];
    }
    self.progress = 0;
    self.timerLabel.text = @"00:00";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"PRACTICE_TIME"]) {
        int timeduration = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PRACTICE_TIME"] intValue];
        [self setTimeLabelWithDuration:timeduration];
    }
    [self setNeedsDisplay];
}

#pragma mark draw progress
- (void)drawRect:(CGRect)rect {
    [self drawFramePie:self.bounds color:[UIColor colorWithWhite:1.0 alpha:0.5]];
    [self drawFillPie:rect margin:self.frameWidth color:self.progressColor percentage:self.progress];
    [self drawFillProgress:rect margin:self.frameWidth color:[UIColor whiteColor] percentage:self.progress];
}

- (void)drawFillPie:(CGRect)rect margin:(CGFloat)margin color:(UIColor *)color percentage:(CGFloat)percentage {
    CGFloat radius = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) * 0.5 - margin;
    CGFloat centerX = CGRectGetWidth(rect) * 0.5;
    CGFloat centerY = CGRectGetHeight(rect) * 0.5;
    
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(cgContext, [color CGColor]);
    CGContextMoveToPoint(cgContext, centerX, centerY);
    CGContextAddArc(cgContext, centerX, centerY, radius, (CGFloat) (-M_PI_2 + M_PI * 2 * (percentage)), (CGFloat) (-M_PI_2 + M_PI * 2 * (1)), 0);
    CGContextClosePath(cgContext);
    CGContextFillPath(cgContext);
}

// FILL COLOR
- (void)drawFillProgress:(CGRect)rect margin:(CGFloat)margin color:(UIColor *)color percentage:(CGFloat)percentage {
    CGFloat radius = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) * 0.5 - 5;
    CGFloat centerX = CGRectGetWidth(rect) * 0.5;
    CGFloat centerY = CGRectGetHeight(rect) * 0.5;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10);
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    
    //    CGContextAddArc(context, centerX, centerY, radius, (CGFloat) -M_PI_2, (CGFloat) (-M_PI_2 + M_PI * 2 * (percentage)), 0);
    CGContextAddArc(context, centerX, centerY, radius, (CGFloat) (-M_PI_2 + M_PI * 2 * (percentage)), (CGFloat) (-M_PI_2 + M_PI * 2 * (1)), 0);
    CGContextStrokePath(context);
}

- (void)drawFramePie:(CGRect)rect color:(UIColor *)color{
    
    //    CGFloat radius = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) * 0.5-(rect.size.width/1.2);
    CGFloat radius = self.bounds.size.height/4;
    CGFloat centerX = CGRectGetWidth(rect) * 0.5;
    CGFloat centerY = CGRectGetHeight(rect) * 0.5;
    
    self.timerLabel.frame = rect;
    
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(cgContext, [color CGColor]);
    CGContextMoveToPoint(cgContext, centerX, centerY);
    CGContextAddArc(cgContext, centerX, centerY, radius, (CGFloat) -M_PI_2, (CGFloat) (-M_PI_2 + M_PI * 2 * 100), 0);
    CGContextClosePath(cgContext);
    CGContextFillPath(cgContext);
}

@end
