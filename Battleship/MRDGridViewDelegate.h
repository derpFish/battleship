//
//  MRDGridViewDelegate.h
//  Battleship
//
//  Created by Michael Dorsey on 2/25/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MRDGridViewTypes.h"

@class MRDGridView;

@protocol MRDGridViewDelegate <NSObject>

@optional
- (void)gridView:(MRDGridView *)gridView tappedGridCell:(MRDGridCell)cell;

@end