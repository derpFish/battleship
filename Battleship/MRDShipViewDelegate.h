//
//  MRDShipViewDelegate.h
//  Battleship
//
//  Created by Michael Dorsey on 2/27/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MRDShipView;

@protocol MRDShipViewDelegate <NSObject>

@optional
- (void)shipView:(MRDShipView *)shipView tappedAtPoint:(CGPoint)point;

@end
