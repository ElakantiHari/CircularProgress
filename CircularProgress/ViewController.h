//
//  ViewController.h
//  CircularProgress
//
//  Created by Hari Krishna  on 20/07/16.
//  Copyright © 2016 VrindaTechApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKProgressTimer.h"

@interface ViewController : UIViewController<HKProgressTimerDelegate>
@property (weak, nonatomic) IBOutlet HKProgressTimer *hTimer;


@end

