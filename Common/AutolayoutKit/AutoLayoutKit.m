//
//  AutoLayoutKit.m
//  SeMob
//
//  Created by yang bin on 15/4/29.
//
//

#import "AutoLayoutKit.h"

@implementation NSLayoutConstraint (semobKit)
- (void)uninstall
{
    if ([self respondsToSelector:@selector(setActive:)]) {
        //for ios8 and later
        self.active = NO;
    } else {
        NSAssert(self.firstItem || self.secondItem, @"Can't install a constraint with nil firstItem and secondItem.");
        if (self.firstItem) {
            if (self.secondItem) {
                NSAssert([self.firstItem isKindOfClass:[UIView class]] && [self.secondItem isKindOfClass:[UIView class]], @"Can only automatically install a constraint if both items are views.");
                UIView *commonSuperview = [self.firstItem commonSuperViewWithView:self.secondItem];
                [commonSuperview removeConstraint:self];
            } else {
                NSAssert([self.firstItem isKindOfClass:[UIView class]], @"Can only automatically install a constraint if the item is a view.");
                [self.firstItem removeConstraint:self];
            }
        } else {
            NSAssert([self.secondItem isKindOfClass:[UIView class]], @"Can only automatically install a constraint if the item is a view.");
            [self.secondItem removeConstraint:self];
        }
        
    }
}

- (void)install
{
    if ([self respondsToSelector:@selector(setActive:)]) {
        //for ios8 and later
        self.active = YES;
    } else {
        NSAssert(self.firstItem || self.secondItem, @"Can't install a constraint with nil firstItem and secondItem.");
        if (self.firstItem) {
            if (self.secondItem) {
                NSAssert([self.firstItem isKindOfClass:[UIView class]] && [self.secondItem isKindOfClass:[UIView class]], @"Can only automatically install a constraint if both items are views.");
                UIView *commonSuperview = [self.firstItem commonSuperViewWithView:self.secondItem];
                [commonSuperview addConstraint:self];
            } else {
                NSAssert([self.firstItem isKindOfClass:[UIView class]], @"Can only automatically install a constraint if the item is a view.");
                [self.firstItem addConstraint:self];
            }
        } else {
            NSAssert([self.secondItem isKindOfClass:[UIView class]], @"Can only automatically install a constraint if the item is a view.");
            [self.secondItem addConstraint:self];
        }

    }
}

@end

@implementation NSArray (AutoLayoutKit)

- (void)autoLayoutInstall
{
    for (NSLayoutConstraint *constraint in self) {
        NSAssert([constraint isKindOfClass:[NSLayoutConstraint class]], @"Array contains object which is not NSLayoutConstraint");
        if ([constraint isKindOfClass:[NSLayoutConstraint class]]) {
            [constraint install];
        }
    }
}

- (void)autoLayoutUninstall
{
    for (NSLayoutConstraint *constraint in self) {
        NSAssert([constraint isKindOfClass:[NSLayoutConstraint class]], @"Array contains object which is not NSLayoutConstraint");
        if ([constraint isKindOfClass:[NSLayoutConstraint class]]) {
            [constraint uninstall];
        }
    }
}

@end

@implementation UIView (AutoLayoutKit)

- (UIView *)commonSuperViewWithView:(UIView *)otherView
{
    UIView *commonSuperview = nil;
    UIView *startView = self;
    do {
        if ([otherView isDescendantOfView:startView]) {
            commonSuperview = startView;
        }
        startView = startView.superview;
    } while (startView && !commonSuperview);
//    NSAssert(commonSuperview, @"Can't constrain two views that do not share a common superview. Make sure that both views have been added into the same view hierarchy.");
    return commonSuperview;
}

@end