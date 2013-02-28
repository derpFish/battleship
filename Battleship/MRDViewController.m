//
//  MRDViewController.m
//  Battleship
//
//  Created by Michael Dorsey on 2/25/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import "MRDGridView.h"
#import "MRDShipView.h"
#import "MRDViewController.h"

@interface MRDViewController ()

@property (nonatomic, strong) MRDGridView *gridView;
@property (nonatomic, assign) IBOutlet UILabel *gridCellLabel;
@property (nonatomic, strong) NSArray *shipViews;

@end

@implementation MRDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self _createGridView];
	[self _createShipViews];
}

#pragma mark - MRDGridViewDelegate
- (void)gridView:(MRDGridView *)gridView tappedGridCell:(MRDGridCell)cell;
{
	if(cell.row != NSNotFound && cell.column != NSNotFound) {
		self.gridCellLabel.text = [self _nameForCell:cell];
	}
}

#pragma mark - MRDShipViewDelegate
- (void)shipView:(MRDShipView *)shipView tappedAtPoint:(CGPoint)point;
{
	assert([self.shipViews containsObject:shipView]);
	
	CGPoint pointInGrid = [self.gridView convertPoint:point fromView:shipView];
	MRDGridCell tappedCell = [self.gridView cellForPoint:pointInGrid];
	[self gridView:self.gridView tappedGridCell:tappedCell];
}

#pragma mark - private helpers
- (NSString *)_nameForCell:(MRDGridCell)cell;
{
	NSString * const alpha = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	return [NSString stringWithFormat:@"%@%u", [alpha substringWithRange:NSMakeRange(cell.row, 1)], cell.column + 1];
}

- (void)_createGridView;
{
	assert(self.gridView == nil);
	
	self.gridView = [[MRDGridView alloc] initWithRows:6 columns:6];
	self.gridView.delegate = self;
	
	// constraints
	NSDictionary *contraintViews = @{ @"grid" : self.gridView };
	NSDictionary *contraintMetrics = @{ @"w" : @(self.gridView.frame.size.width), @"h" : @(self.gridView.frame.size.height) };
	
	[self.gridView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[grid(w)]" options:0 metrics:contraintMetrics views:contraintViews]];
	[self.gridView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[grid(h)]" options:0 metrics:contraintMetrics views:contraintViews]];
	self.gridView.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self.view addSubview:self.gridView];
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gridView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[grid]" options:0 metrics:contraintMetrics views:contraintViews]];
}

- (void)_createShipViews;
{
	assert(self.shipViews == nil);
	
	NSMutableArray *shipViews = [NSMutableArray array];
	
	for (CGFloat width = 100.0f; width <= 200.0f; width += 50.0f) {
		[shipViews addObject:[[MRDShipView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, 50.0f)]];
	}
	
	self.shipViews = shipViews;

	for (MRDShipView *shipView in self.shipViews) {
		shipView.delegate = self;
		[self.view addSubview:shipView];
	}
}
@end
