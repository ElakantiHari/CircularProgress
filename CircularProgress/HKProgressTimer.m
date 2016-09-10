//
//  HKProgressTimer.m
//  CircularProgress
//
//  Created by HariKrishna  on 20/07/16.
//  Copyright © 2016 Apptitude. All rights reserved.
//

#import "HKProgressTimer.h"
#import "NSTimer+Extension.h"

@interface HKProgressTimer ()

@property(nonatomic) CGFloat progress;
@property(nonatomic) CGFloat floatSecond;
@property(nonatomic) int timeDuration;
@property(nonatomic) int ticks;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, copy) HKProgressBlock block;
@property(nonatomic, strong) UILabel *timerLabel;

@end

@implementation HKProgressTimer

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

        self.progressColor = [UIColor whiteColor];
        self.progressBorderColor = [UIColor redColor];
        self.progressCircleColor = [UIColor blueColor];
        self.progressDirection = ProgressDirectionFillClockwise;
        
    }
    return self;
}

#pragma mark - progress SetUp

// Setters
- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
}

- (void)setProgressBorderColor:(UIColor *)progressBorderColor {
    _progressBorderColor = progressBorderColor;
}

- (void)setProgressCircleColor:(UIColor *)progressCircleColor {
    _progressCircleColor =  progressCircleColor;
}

- (void)setProgressDirection:(ProgressDirection)progressDirection {
    _progressDirection = progressDirection;
}

- (void)setupParams {
    self.backgroundColor = [UIColor clearColor];
    
    self.timerLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.timerLabel.textAlignment = NSTextAlignmentCenter;
    self.timerLabel.font = [UIFont boldSystemFontOfSize:25.0f];
    self.timerLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.timerLabel];
    
    self.frameWidth = 10;
    self.progress = 0;
    self.timerLabel.text = @"00:00";
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"PRACTICE_TIME"]) {
        int timeduration = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PRACTICE_TIME"] intValue];
        [self setTimeLabelWithDuration:timeduration];
    }
}

#pragma mark - progress DataSource

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

- (void)startWithBlock:(HKProgressBlock)block withTimeInterval:(int)timedDuration{
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

#pragma mark - progress Delegate

- (void)pause {
    if (self.timer.isValid) {
        [self.timer pauseTimer];
    }
}

- (void)resume {
    if (self.timer.isValid) {
        [self.timer resumeTimer];
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

- (void)invalidateBackgroundTimer {
    if (self.timer.isValid) {
        [self.timer invalidate];
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

#pragma mark - Draw progress

- (void)drawRect:(CGRect)rect {
    [self drawFillPie:rect margin:self.frameWidth color:_progressColor percentage:self.progress];
    [self drawFillProgress:rect margin:self.frameWidth color:_progressBorderColor percentage:self.progress];
    [self drawFramePie:self.bounds color:_progressCircleColor];
}

- (void)drawFillPie:(CGRect)rect margin:(CGFloat)margin color:(UIColor *)color percentage:(CGFloat)percentage {
    CGFloat radius = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) * 0.5 - margin;
    CGFloat centerX = CGRectGetWidth(rect) * 0.5;
    CGFloat centerY = CGRectGetHeight(rect) * 0.5;
    
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(cgContext, [color CGColor]);
    CGContextMoveToPoint(cgContext, centerX, centerY);

    switch (self.progressDirection) {
        case ProgressDirectionFillClockwise:    // fill clock wise
            CGContextAddArc(cgContext, centerX, centerY, radius, (CGFloat) -M_PI_2, (CGFloat) (-M_PI_2 + M_PI * 2 * (percentage)), 0);
            break;
        case ProgressDirectionUnFillClockwise:  // unfill clockwise
            CGContextAddArc(cgContext, centerX, centerY, radius, (CGFloat) (-M_PI_2 + M_PI * 2 * (percentage)), (CGFloat) (-M_PI_2 + M_PI * 2 * (1)), 0);
            break;
        case ProgressDirectionFillAntiClockwise:    //fill anticlockwise
            CGContextAddArc(cgContext, centerX, centerY, radius, (CGFloat) (-M_PI_2 + M_PI * (-2) * (percentage)), (CGFloat) (-M_PI_2 + M_PI * (-2) * (1)), 0);
            break;
        case ProgressDirectionUnFillAntiClockwise:  //unfill anticlockwise
            CGContextAddArc(cgContext, centerX, centerY, radius, (CGFloat) -M_PI_2, (CGFloat) (-M_PI_2 + M_PI * (-2) * (percentage)), 0);
            break;
        default:
            break;
    }

    CGContextClosePath(cgContext);
    CGContextFillPath(cgContext);
}

// FILL COLOR
- (void)drawFillProgress:(CGRect)rect margin:(CGFloat)margin color:(UIColor *)color percentage:(CGFloat)percentage {
    CGFloat radius = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) * 0.5 - 5;
    CGFloat centerX = CGRectGetWidth(rect) * 0.5;
    CGFloat centerY = CGRectGetHeight(rect) * 0.5;
    
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(cgContext, 10);
    CGContextSetStrokeColorWithColor(cgContext, [color CGColor]);
    
    switch (self.progressDirection) {
        case ProgressDirectionFillClockwise:    // fill clock wise
            CGContextAddArc(cgContext, centerX, centerY, radius, (CGFloat) -M_PI_2, (CGFloat) (-M_PI_2 + M_PI * 2 * (percentage)), 0);
            break;
        case ProgressDirectionUnFillClockwise:  // unfill clockwise
            CGContextAddArc(cgContext, centerX, centerY, radius, (CGFloat) (-M_PI_2 + M_PI * 2 * (percentage)), (CGFloat) (-M_PI_2 + M_PI * 2 * (1)), 0);
            break;
        case ProgressDirectionFillAntiClockwise:    //fill anticlockwise
            CGContextAddArc(cgContext, centerX, centerY, radius, (CGFloat) (-M_PI_2 + M_PI * (-2) * (percentage)), (CGFloat) (-M_PI_2 + M_PI * (-2) * (1)), 0);
            break;
        case ProgressDirectionUnFillAntiClockwise:  //unfill anticlockwise
            CGContextAddArc(cgContext, centerX, centerY, radius, (CGFloat) -M_PI_2, (CGFloat) (-M_PI_2 + M_PI * (-2) * (percentage)), 0);
            break;
        default:
            break;
    }
    
    CGContextStrokePath(cgContext);
}

/*! IT IS FOR CENTER CIRCLE */
- (void)drawFramePie:(CGRect)rect color:(UIColor *)color{
//    CGFloat radius = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) * 0.5-(rect.size.width/1.2);
    CGFloat radius = self.bounds.size.height/4;
    CGFloat centerX = CGRectGetWidth(rect) * 0.5;
    CGFloat centerY = CGRectGetHeight(rect) * 0.5;
    
    self.timerLabel.frame = rect;
    
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(cgContext, [color CGColor]);
    CGContextSetAlpha(cgContext, 0.5f);
    CGContextMoveToPoint(cgContext, centerX, centerY);
    CGContextAddArc(cgContext, centerX, centerY, radius, (CGFloat) -M_PI_2, (CGFloat) (-M_PI_2 + M_PI * 2 * 100), 0);
    CGContextClosePath(cgContext);
    CGContextFillPath(cgContext);
}

@end
