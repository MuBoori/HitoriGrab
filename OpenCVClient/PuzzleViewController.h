//
//  PuzzleViewController.h
//  OpenCVClient
//
//  Created by Mujtaba Alboori on 18/02/2012.
//  Copyright (c) 2012 Aptogo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HitoriCell.h"
#import "HitoriRules.h"
#import "MBProgressHUD.h"
@interface PuzzleViewController : UIViewController 
{
 
    MBProgressHUD *HUD;
    NSMutableArray *buttonTracker;
    NSMutableArray *hitoriInArray;
}
@property (retain, nonatomic) IBOutlet UIToolbar *ToolBar;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *itemButton;

- (IBAction)pleaseClick:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *PuzzleAreaView;
@end
