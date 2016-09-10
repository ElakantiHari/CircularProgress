//
//  ViewController.h
//  CircularProgress
//
//  Created by HariKrishna  on 20/07/16.
//  Copyright © 2016 Apptitude. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKProgressTimer.h"

@interface ViewController : UIViewController<HKProgressTimerDelegate>

@property (weak, nonatomic) IBOutlet HKProgressTimer *hTimer;

@end

