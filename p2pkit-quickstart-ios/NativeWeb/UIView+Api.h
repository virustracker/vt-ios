//
//  UIView+Api.h
//  Kinofinder
//
//  Created by Artur Olszak on 31/03/16.
//  Copyright © 2016 bam! interactive marketing GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KFEdge) {
    KFEdgeTop,
    KFEdgeRight,
    KFEdgeBottom,
    KFEdgeLeft
};

@interface UIView (Api)

/**
 @brief Returns constraint with selected attribute - if it is existing on the view or its superview
 */
- (NSLayoutConstraint *)constraintWithAttribute:(NSLayoutAttribute)attribute;

/** */
- (void)addConstraintsToCenterInSuperview;

/** */
- (void)addConstraintsToFillSuperview;
/** */
- (void)addConstraintsToFillSuperviewWithEdgeInsets:(UIEdgeInsets)edgeInsets;

/** */
- (void)addConstraintsToCenterInSuperviewWithSize:(CGSize)size andOptionalBottomConstraintConstantValue:(NSNumber *)bottomConstraintConstantValue;

/** */
- (void)addConstraintsToStickToEdge:(KFEdge)edge ofView:(UIView *)view withSize:(CGFloat)size;

@end
