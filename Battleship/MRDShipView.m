//
//  MRDShipView.m
//  Battleship
//
//  Created by Michael Dorsey on 2/25/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import "MRDShipView.h"

@interface MRDShipView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIBezierPath *interiorRectPath;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotationGestureRecognizer;

@end

@implementation MRDShipView

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) {
		return nil;
	}
	
	self.interiorRectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset([self bounds], 5.0f, 5.0f) cornerRadius:2.0f];
	
	self.backgroundColor = [UIColor greenColor];
	
	self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapped:)];
	[self addGestureRecognizer:self.tapGestureRecognizer];
	
	self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panned:)];
	self.panGestureRecognizer.delegate = self;
	[self addGestureRecognizer:self.panGestureRecognizer];
	
	self.rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(_rotated:)];
	self.rotationGestureRecognizer.delegate = self;
	[self addGestureRecognizer:self.rotationGestureRecognizer];
	
	return self;
}

- (void)drawRect:(CGRect)rect;
{
	[super drawRect:rect];
	
	[[UIColor blackColor] set];
	[self.interiorRectPath stroke];
}

#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
{
	return (gestureRecognizer == self.panGestureRecognizer && otherGestureRecognizer == self.rotationGestureRecognizer) || (gestureRecognizer == self.rotationGestureRecognizer && otherGestureRecognizer == self.panGestureRecognizer);
}

#pragma mark - private helpers
- (void)_tapped:(id)sender;
{
	assert(sender == self.tapGestureRecognizer);
	
	if ([self.delegate respondsToSelector:@selector(shipView:tappedAtPoint:)]) {
		CGPoint tappedPoint = [self.tapGestureRecognizer locationInView:self];
		CGPoint actualPoint = CGPointApplyAffineTransform(tappedPoint, CGAffineTransformInvert(self.transform));
		[self.delegate shipView:self tappedAtPoint:actualPoint];
	}
}

- (void)_panned:(id)sender;
{
	assert(sender == self.panGestureRecognizer);
	
	CGPoint translation = [self.panGestureRecognizer translationInView:self];
	CGPoint effectiveTranslation = CGPointApplyAffineTransform(translation, self.transform);
	self.center = (CGPoint){.x = self.center.x + effectiveTranslation.x, .y = self.center.y + effectiveTranslation.y};
	[self.panGestureRecognizer setTranslation:CGPointZero inView:self];
}

- (void)_rotated:(id)sender;
{
	assert(sender == self.rotationGestureRecognizer);
	
	CGFloat rotation = self.rotationGestureRecognizer.rotation;
	self.transform = CGAffineTransformConcat(self.transform, CGAffineTransformMakeRotation(rotation));
	self.rotationGestureRecognizer.rotation = 0.0f;
}

@end
