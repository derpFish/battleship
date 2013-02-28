//
//  MRDGridView.h
//  Battleship
//
//  Created by Michael Dorsey on 2/25/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MRDGridViewDelegate.h"

@interface MRDGridView : UIView

@property (nonatomic, readonly) NSUInteger numberOfRows;
@property (nonatomic, readonly) NSUInteger numberOfCols;

@property (nonatomic, copy) UIColor *gridColor;

@property (nonatomic, weak) id<MRDGridViewDelegate> delegate;

- (id)initWithRows:(NSUInteger)rows columns:(NSUInteger)columns;

- (MRDGridCell)cellForPoint:(CGPoint)point;

@end
