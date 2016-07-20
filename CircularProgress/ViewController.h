//
//  ViewController.h
//  CircularProgress
//
//  Created by Hari Krishna  on 20/07/16.
//  Copyright © 2016 VrindaTechApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPProgressTimer.h"

@interface ViewController : UIViewController<CPProgressTimerDelegate>
@property (weak, nonatomic) IBOutlet CPProgressTimer *hTimer;


@end

