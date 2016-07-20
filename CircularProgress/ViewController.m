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
    self.hTimer.progressBorderColor = [UIColor orangeColor];
    self.hTimer.delegate = self;
    
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
- (void)didStopProgressTimer:(CPProgressTimer *)progressTimer percentage:(CGFloat)percentage {
//    NSLog(@"didStopProgressTimer - Percentage = %f",percentage);
}

- (void)didUpdateProgressTimer:(CPProgressTimer *)progressTimer percentage:(CGFloat)percentage {
//    NSLog(@"didUpdateProgressTimer - Percentage = %f",percentage);
}

- (void)willUpdateProgressTimer:(CPProgressTimer *)progressTimer percentage:(CGFloat)percentage {
//    NSLog(@"willUpdateProgressTimer - Percentage = %f",percentage);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
