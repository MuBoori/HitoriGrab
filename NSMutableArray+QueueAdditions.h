//
//  NSMutableArray+QueueAdditions.h
//  HitioriGrab
//
//  Created by Mujtaba Alboori on 09/03/2012.
//  Copyright (c) 2012 Aptogo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableArray (QueueAdditions)
- (id) dequeue;
- (void) enqueue:(id)obj;
@end
