//
//  MRDGridView.m
//  Battleship
//
//  Created by Michael Dorsey on 2/25/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import "MRDGridView.h"
#import "MRDGridViewDelegate.h"

#import <QuartzCore/QuartzCore.h>

#define GRID_CELL_SIZE (50.0f)

@interface MRDGridView ()

@property (nonatomic, readwrite) NSUInteger numberOfRows;
@property (nonatomic, readwrite) NSUInteger numberOfCols;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

- (MRDGridCell)cellForPoint:(CGPoint)pointInView;

@end

@implementation MRDGridView

- (id)initWithFrame:(CGRect)frame
{
    CGFloat width = frame.size.width;
	CGFloat height = frame.size.height;
	
	if (fmodf(width, GRID_CELL_SIZE) > FLT_EPSILON || fmodf(height, GRID_CELL_SIZE) > FLT_EPSILON) {
		return nil;
	}
	
	NSUInteger rows = floorf(height / GRID_CELL_SIZE);
	NSUInteger cols = floorf(width / GRID_CELL_SIZE);

	return [self initWithRows:rows columns:cols];
}

- (id)initWithRows:(NSUInteger)rows columns:(NSUInteger)cols;
{
	if(!(self = [super initWithFrame:(CGRect){.origin = CGPointZero, .size = (CGSize){.width = GRID_CELL_SIZE * cols, .height = GRID_CELL_SIZE * rows}}])) {
		return nil;
	}
	
	self.numberOfRows = rows;
	self.numberOfCols = cols;
	
	self.gridColor = [UIColor blackColor];
	self.backgroundColor = [UIColor lightGrayColor];
	
	self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
	[self addGestureRecognizer:self.tapGestureRecognizer];
	
	return self;
}

- (MRDGridCell)cellForPoint:(CGPoint)pointInView;
{
	NSInteger row = floorf(pointInView.y / GRID_CELL_SIZE);
	if (row < 0 || row >= self.numberOfRows) {
		row = NSNotFound;
	}
	
	NSInteger col = floorf(pointInView.x / GRID_CELL_SIZE);
	if (col < 0 || col >= self.numberOfCols) {
		col = NSNotFound;
	}
	
	return (MRDGridCell){.row = row,.column = col};
}

- (void)tapped:(id)sender;
{
	assert(sender == self.tapGestureRecognizer);
	
	if ([self.delegate respondsToSelector:@selector(gridView:tappedGridCell:)]) {
		CGPoint tappedPoint = [self.tapGestureRecognizer locationInView:self];
		MRDGridCell tappedCell = [self cellForPoint:tappedPoint];
		[self.delegate gridView:self tappedGridCell:tappedCell];
	}
}

- (void)setGridColor:(UIColor *)gridColor;
{
	_gridColor = gridColor;
	
	self.layer.borderColor = [self.gridColor CGColor];
	self.layer.borderWidth = 1.0f;
}

- (void)drawRect:(CGRect)rect;
{
	[super drawRect:rect];
	
	[self.gridColor set];
	
	for (NSUInteger rowIdx = 1; rowIdx < self.numberOfRows; rowIdx++) {
		[self _drawLineFromPoint:(CGPoint){.x = 0, .y = rowIdx * GRID_CELL_SIZE - 0.5f} toPoint:(CGPoint){.x = self.frame.size.width, .y = rowIdx * GRID_CELL_SIZE - 0.5f}];
	}
	
	for (NSUInteger colIdx = 1; colIdx < self.numberOfCols; colIdx++) {
		[self _drawLineFromPoint:(CGPoint){.x = colIdx * GRID_CELL_SIZE - 0.5f, .y = 0} toPoint:(CGPoint){.x = colIdx * GRID_CELL_SIZE - 0.5f, .y = self.frame.size.height}];
	}
}

- (void)_drawLineFromPoint:(CGPoint)start toPoint:(CGPoint)end;
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSaveGState(ctx);
	CGContextBeginPath(ctx);
	CGContextMoveToPoint(ctx, start.x, start.y);
	CGContextAddLineToPoint(ctx, end.x, end.y);
	CGContextStrokePath(ctx);
	CGContextRestoreGState(ctx);
}

@end
