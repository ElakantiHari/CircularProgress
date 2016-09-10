//
//  ViewController.m
//  CircularProgress
//
//  Created by Hari Krishna  on 20/07/16.
//  Copyright © 2016 VrindaTechApps. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   
    
    self.hTimer.progressColor = [UIColor whiteColor];
    self.hTimer.progressBorderColor = [UIColor redColor];
    self.hTimer.progressCircleColor = [UIColor yellowColor];
    self.hTimer.delegate = self;
    [self.hTimer setProgressDirection:ProgressDirectionUnFillClockwise];
     
    
//    NSArray *ary  = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
//    int index = 6;
//    assert(index>0 && ary.count>index);
//    NSAssert(index>0 && ary.count>index, @"array index = %i and array count = %lu", index,(unsigned long)ary.count);
//    NSLog(@"print = %@",ary[index]);
    
}
- (IBAction)startAction:(id)sender {
    
    if ([self.startButton.titleLabel.text isEqualToString:@"start"]) {
        __block CGFloat i = 0;
        [self.hTimer startWithBlock:^CGFloat{
            CGFloat time = 10*300;
            return i++/time;
        } withTimeInterval:300];
        [self.startButton setTitle:@"stop" forState:UIControlStateNormal];
    } else {
        [self.hTimer stop];
        [self.startButton setTitle:@"start" forState:UIControlStateNormal];
    }
    
    
}
- (IBAction)pauseAction:(id)sender {
}


#pragma mark - CPProgreddTimer Delegates
- (void)didStopProgressTimer:(HKProgressTimer *)progressTimer percentage:(CGFloat)percentage {
//    NSLog(@"didStopProgressTimer - Percentage = %f",percentage);
}

- (void)didUpdateProgressTimer:(HKProgressTimer *)progressTimer percentage:(CGFloat)percentage {
//    NSLog(@"didUpdateProgressTimer - Percentage = %f",percentage);
}

- (void)willUpdateProgressTimer:(HKProgressTimer *)progressTimer percentage:(CGFloat)percentage {
//    NSLog(@"willUpdateProgressTimer - Percentage = %f",percentage);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
