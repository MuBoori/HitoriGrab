//
//  DataAppDataObject.m
//  OpenCVClient
//
//  Created by Mujtaba Alboori on 20/02/2012.
//  Copyright (c) 2012 Aptogo Limited. All rights reserved.
//

#import "DataAppDataObject.h"

@implementation DataAppDataObject 

@synthesize HitoriMatrix;

- (void) dealloc
{

    self.HitoriMatrix = nil;
    [super dealloc];
}

@end
