//
//  PuzzleViewController.h
//  OpenCVClient
//
//  Created by Mujtaba Alboori on 18/02/2012.
//  Copyright (c) 2012 Aptogo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "HitoriCell.h"
@interface PuzzleViewController : UIViewController <AQGridViewDataSource,AQGridViewDelegate>
{
 
    AQGridView *_gridView;
}
@end
