//
//  UIView+Api.m
//  Kinofinder
//
//  Created by Artur Olszak on 31/03/16.
//  Copyright © 2016 bam! interactive marketing GmbH. All rights reserved.
//

#import "UIView+Api.h"

@implementation UIView (Api)

- (NSLayoutConstraint *)constraintWithAttribute:(NSLayoutAttribute)attribute {
    NSLayoutConstraint *neededConstraint = nil;
    
    // Search in superview
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if ((constraint.firstItem == self && constraint.firstAttribute == attribute) ||
            (constraint.secondItem == self && constraint.secondAttribute == attribute)
            ) {
            neededConstraint = constraint;
        }
    }
    
    // Search in the view
    if (neededConstraint == nil) {
        for (NSLayoutConstraint *constraint in self.constraints) {
            if ((constraint.firstItem == self && constraint.firstAttribute == attribute) ||
                (constraint.secondItem == self && constraint.secondAttribute == attribute)
                ) {
                neededConstraint = constraint;
            }
        }
    }
    return neededConstraint;
}

- (void)addConstraintsToCenterInSuperview {
    if (self.superview != nil) {
        NSDictionary *views = @{
                                @"view":self,
                                @"superview":self.superview
                                };
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview]-(<=1)-[view]"
                                                                          options:NSLayoutFormatAlignAllCenterX
                                                                          metrics:nil
                                                                            views:views]];
        [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[superview]-(<=1)-[view]"
                                                                          options:NSLayoutFormatAlignAllCenterY
                                                                          metrics:nil
                                                                            views:views]];
    }
}

- (void)addConstraintsToCenterInSuperviewWithSize:(CGSize)size andOptionalBottomConstraintConstantValue:(NSNumber *)bottomConstraintConstantValue {
    if (self.superview != nil) {
        NSDictionary *views = @{
                                @"view":self,
                                @"superview":self.superview
                                };
        NSDictionary *metrics = @{
                                @"width":@(size.width),
                                @"height":@(size.height),
                                @"bottom":@(bottomConstraintConstantValue.doubleValue),
                                };
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview]-(<=1)-[view(==height)]"
                                                                               options:NSLayoutFormatAlignAllCenterX
                                                                               metrics:metrics
                                                                                 views:views]];
        [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[superview]-(<=1)-[view(==width)]"
                                                                               options:NSLayoutFormatAlignAllCenterY
                                                                               metrics:metrics
                                                                                 views:views]];
        if (bottomConstraintConstantValue != nil) {
            [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-(bottom)-|"
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:views]];
        }
    }
}

- (void)addConstraintsToFillSuperview {
    [self addConstraintsToFillSuperviewWithEdgeInsets:UIEdgeInsetsZero];
}

- (void)addConstraintsToFillSuperviewWithEdgeInsets:(UIEdgeInsets)edgeInsets {
    if (self.superview != nil) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *views = @{
                                @"view":self,
                                @"superview":self.superview
                                };
        NSDictionary *metrics = @{
                                  @"marginLeft":@(edgeInsets.left),
                                  @"marginRight":@(edgeInsets.right),
                                  @"marginTop":@(edgeInsets.top),
                                  @"marginBottom":@(edgeInsets.bottom)
                                  };
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(marginTop)-[view]-(marginBottom)-|"
                                                                               options:0
                                                                               metrics:metrics
                                                                                 views:views]];
        [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(marginLeft)-[view]-(marginRight)-|"
                                                                               options:0
                                                                               metrics:metrics
                                                                                 views:views]];
    }
}

- (void)addConstraintsToStickToEdge:(KFEdge)edge ofView:(UIView *)view withSize:(CGFloat)size {
    if (self.superview != nil) {
        NSDictionary *views = @{
                                @"view":self,
                                @"toView":view,
                                @"superview":self.superview
                                };
        NSDictionary *metrics = @{
                                  @"size":@(size)
                                  };
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        if (edge == KFEdgeTop) {
            
            [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[toView]-(0)-[view(==size)]"
                                                                                   options:0
                                                                                   metrics:metrics
                                                                                     views:views]];
            [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[view]-(0)-|"
                                                                                   options:0
                                                                                   metrics:metrics
                                                                                     views:views]];
            
        } else if (edge == KFEdgeRight) {
            
            [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view(==size)]-(0)-[toView]"
                                                                                   options:0
                                                                                   metrics:metrics
                                                                                     views:views]];
            [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|"
                                                                                   options:0
                                                                                   metrics:metrics
                                                                                     views:views]];
            
        } else if (edge == KFEdgeBottom) {
            
            [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view(==size)]-(0)-[toView]"
                                                                                   options:0
                                                                                   metrics:metrics
                                                                                     views:views]];
            [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[view]-(0)-|"
                                                                                   options:0
                                                                                   metrics:metrics
                                                                                     views:views]];
            
        } else if (edge == KFEdgeLeft) {
            
            [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[toView]-(0)-[view(==size)]"
                                                                                   options:0
                                                                                   metrics:metrics
                                                                                     views:views]];
            [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|"
                                                                                   options:0
                                                                                   metrics:metrics
                                                                                     views:views]];
            
        }
    }
}

@end
