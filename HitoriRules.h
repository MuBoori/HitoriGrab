//
//  HitoriRules.h
//  HitioriGrab
//
//  Created by Mujtaba Alboori on 08/03/2012.
//  Copyright (c) 2012 Aptogo Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HitoriCell.h"
@interface HitoriRules : NSObject
{

    NSMutableArray *hitoriInArray;
    
}

@property NSMutableArray *hitoriInArray;

- (BOOL) firstRule;
- (BOOL) secondRule;
- (BOOL) thirdRule;

@end
