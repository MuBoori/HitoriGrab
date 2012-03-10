//
//  HitoriPoint.m
//  HitioriGrab
//
//  Created by Mujtaba Alboori on 09/03/2012.
//  Copyright (c) 2012 Aptogo Limited. All rights reserved.
//

#import "HitoriPoint.h"

@implementation HitoriPoint
@synthesize x= _x,y = _y;


-(HitoriPoint*) initWithNumer: (int) x andY: (int) y
{

    self = [super init];

    if (self) {
        self.x = _x ;
        self.y = _y;
        
    }
    return self;
}
@end
