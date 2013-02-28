//
//  MRDShipView.h
//  Battleship
//
//  Created by Michael Dorsey on 2/25/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MRDShipViewDelegate.h"

@interface MRDShipView : UIView

@property (nonatomic, weak) id<MRDShipViewDelegate> delegate;

@end
