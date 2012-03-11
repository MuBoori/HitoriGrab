//
//  HitoriRules.m
//  HitioriGrab
//
//  Created by Mujtaba Alboori on 08/03/2012.
//  Copyright (c) 2012 Aptogo Limited. All rights reserved.
//

#import "HitoriRules.h"
#import "NSMutableArray+QueueAdditions.h"
@implementation HitoriRules
@synthesize hitoriInArray;


-(BOOL) firstRule
{
    
    // column
    for (int y = 0; hitoriInArray.count > y ; y++) {
        for (int x = 0; hitoriInArray.count > x; x++) {
            HitoriCell *tempCell = [[hitoriInArray objectAtIndex:y] objectAtIndex:x];
            for (int yy = 0; hitoriInArray.count > yy; yy++) {
                
                HitoriCell *anotherTempCell = [[hitoriInArray objectAtIndex:yy] objectAtIndex:x];

                    
                  
                if (tempCell.number == anotherTempCell.number) {
                    if (tempCell.Status == CELL_NO_MULTIPLE) {
                        tempCell.Status = CELL_MULTIPLE_PER_RAW;
                    }
                    if (tempCell.Status == CELL_MULTIPLE_PER_COLUMN) {
                        tempCell.Status =CELL_MULTIPLE_PER_RAW_AND_COLUMN;
                    
                    }
                    if (!anotherTempCell.Hidden && !tempCell.Hidden && yy != y) {
                        
                        NSLog(@"Rule 1 is voilated at y = %d and %d",y,x);

                        return false;
                    }else {
                       
                    }
                    
                } 
                    
               
                
            }
        }
    }

    //row
    for (int y = 0; hitoriInArray.count > y ; y++) {
        for (int x = 0; hitoriInArray.count > x; x++) {
            HitoriCell *tempCell = [[hitoriInArray objectAtIndex:y] objectAtIndex:x];
            for (int xx = 0; hitoriInArray.count > xx; xx++) {

                HitoriCell *anotherTempCell = [[hitoriInArray objectAtIndex:y] objectAtIndex:xx];
                
                if (tempCell.number == anotherTempCell.number) {
                    if (tempCell.Status == CELL_NO_MULTIPLE) {
                        tempCell.Status = CELL_MULTIPLE_PER_COLUMN;
                    }
                    if (tempCell.Status == CELL_MULTIPLE_PER_RAW) {
                        tempCell.Status =CELL_MULTIPLE_PER_RAW_AND_COLUMN;
                        
                    }
                    if (!anotherTempCell.Hidden && !tempCell.Hidden && xx != x) {
                        NSLog(@"Rule 1 is voilated at y = %d and %d",y,x);
                        return false;

                    }else {
                        //NSLog(@"Rule 1 is voilated at y = %d and %d",y,x);
                    }
                }
                
            }
        }
    }
    
    

    NSLog(@"It all right");
    return true;

}

- (BOOL) secondRule
{


    for (int y = 0; hitoriInArray.count > y ; y++) {
        for (int x = 0; hitoriInArray.count > x; x++) {
            HitoriCell *tempCell1 = [[hitoriInArray objectAtIndex:y] objectAtIndex:x];
            




            if (y - 1 >= 0 && y+1 < [[hitoriInArray objectAtIndex:0] count]) {
                HitoriCell *tempCell2 = [[hitoriInArray objectAtIndex:y+1] objectAtIndex:x];
                            
                HitoriCell *tempCell4 = [[hitoriInArray objectAtIndex:y-1] objectAtIndex:x];
                if ((tempCell1.Hidden && tempCell4.Hidden) || (tempCell1.Hidden && tempCell2.Hidden)) {
                    NSLog(@"Rule 2 not good");
                    return false;
                }
            }
            if (x - 1 >=0 && x+1 < hitoriInArray.count) {
                            
                HitoriCell *tempCell5 = [[hitoriInArray objectAtIndex:y] objectAtIndex:x-1];
                            
                HitoriCell *tempCell3 = [[hitoriInArray objectAtIndex:y] objectAtIndex:x+1];
                if ((tempCell1.Hidden && tempCell3.Hidden) || (tempCell1.Hidden && tempCell5.Hidden)) {
                    NSLog(@"Rule 3");
                    return false;
                }
            }
        }
    }
    
    return true;

}

-(BOOL) thirdRule
{

    NSLog(@"Method Ok");
    NSMutableArray *reached;
    //BOOL **reached = malloc((hitoriInArray.count*hitoriInArray.count)*sizeof(int));
    HitoriCell *firstCell;
  

    NSMutableArray *painted = [[NSMutableArray alloc] init];
    
    for (int i = 0; hitoriInArray.count > i; i++) {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (int j = 0 ; hitoriInArray.count > j; j++) {
            [temp addObject:[NSNumber numberWithBool:NO]];
        }
        [painted addObject:temp];
    }

    
    //NSLog(@"Painted Ok %@",(NSNumber*)[[painted objectAtIndex:0] objectAtIndex:0]);
    for (int x = 0; hitoriInArray.count > x ; x++) {
        for (int y = 0; hitoriInArray.count > y; y++) {
            NSLog(@"If Ok");

            HitoriCell *tempCell = (HitoriCell*)[[hitoriInArray objectAtIndex:x] objectAtIndex:y];
            if (!tempCell.Hidden) {
                  NSLog(@"If Ok");
                NSMutableArray *queue = [[NSMutableArray alloc] init];
                
                [queue enqueue:((HitoriCell*)tempCell).location];

                while (queue.count != 0) {
                    HitoriPoint *cellPoint = (HitoriPoint*)queue.dequeue;

                    NSLog(@"%d %d",cellPoint.x,cellPoint.y);
                    NSLog(@"WHile Okay %@", [[painted objectAtIndex:cellPoint.x] objectAtIndex:cellPoint.y]);
                    BOOL testpainted = [[[painted objectAtIndex:cellPoint.x] objectAtIndex:cellPoint.y] boolValue];
                    if (!testpainted && !((HitoriCell*)[[hitoriInArray objectAtIndex:cellPoint.x] objectAtIndex:cellPoint.y]).Hidden) {

                         
                        [[painted objectAtIndex:cellPoint.x] replaceObjectAtIndex:cellPoint.y withObject:[NSNumber numberWithBool:YES]];
                        NSLog(@"test Okay %@",[[painted objectAtIndex:cellPoint.x] objectAtIndex:cellPoint.y]);
                    
                        //NSLog(@"Location x: %d and y:%d", cellPoint.x, cellPoint.y);
                        
                         //NSLog(@"if replace Okay");
                    if (cellPoint.x > 0) {
                        
                        HitoriPoint *somePoint = [[HitoriPoint alloc] init];
                        somePoint.x = cellPoint.x -1;
                        somePoint.y = cellPoint.y;
                         

                        [queue enqueue:somePoint];
                        
                        
                    }
                        
                        if (cellPoint.y > 0) {
                            //NSLog(@"Her2 X:%d and Y:%d",x,y);

                            HitoriPoint *somePoint = [[HitoriPoint alloc] init];
                            somePoint.x = cellPoint.x;
                            somePoint.y = cellPoint.y-1;
                            
                            
                            [queue enqueue:somePoint];
                            
                        }
                        if (cellPoint.x < hitoriInArray.count - 1) {


                            HitoriPoint *somePoint = [[HitoriPoint alloc] init];
                            somePoint.x = cellPoint.x + 1;
                            somePoint.y = cellPoint.y;
                            
                            
                            [queue enqueue:somePoint];
                            
                        }
                        
                        if (cellPoint.y < hitoriInArray.count - 1) {

                            HitoriPoint *somePoint = [[HitoriPoint alloc] init];
                            somePoint.x = cellPoint.x ;
                            somePoint.y = cellPoint.y + 1;
                            
                            
                            [queue enqueue:somePoint];
                        }

                        
                        
                    }
                }
                

                for (int x = 0; hitoriInArray.count > x ; x++) {

                    NSLog(@"LOOPing");
                    for (int y = 0; hitoriInArray.count > y; y++) {
                        if (![[[painted objectAtIndex:x] objectAtIndex:y] boolValue] && !((HitoriCell*)[[hitoriInArray objectAtIndex:x] objectAtIndex:y]).Hidden) {
                            NSLog(@"Rule3 fail");
                            return false;
                        }
                    }
                }
 
            /*
    while (queue.count != 0) {
        NSMutableArray *ptr = queue.dequeue;
        
        if (((HitoriCell*)[[ptr objectAtIndex:x] objectAtIndex:y]).Hidden && !([[reached objectAtIndex:x] objectAtIndex:y])) {
            [[reached objectAtIndex:x] replaceObjectAtIndex:y withObject:true];
            
            if (hitoriInArray.count > 0) {
                
            }
        }
    }
    
      */
            }
            
        }
    }
    return true;
}

@end
