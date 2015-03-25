//
//  RootViewController.h
//  BooToothTest
//
//  Created by Ben Van Citters on 3/25/15.
//  Copyright (c) 2015 Ben Van Citters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface RootViewController : UIViewController <UIPageViewControllerDelegate, CBCentralManagerDelegate, CBPeripheralManagerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

