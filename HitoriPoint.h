//
//  HitoriPoint.h
//  HitioriGrab
//
//  Created by Mujtaba Alboori on 09/03/2012.
//  Copyright (c) 2012 Aptogo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HitoriPoint : NSObject
{

    int x;
    int y;
}


@property int x;
@property int y;

-(HitoriPoint*) initWithNumer: (int) x andY: (int) y;
@end
