//
//  AutoLayoutKit.h
//  SeMob
//
//  Created by yang bin on 15/4/29.
//
//

@import UIKit;

@interface NSLayoutConstraint (semobKit)

- (void)install;
- (void)uninstall;

@end

@interface NSArray (AutoLayoutKit)

- (void)autoLayoutInstall;
- (void)autoLayoutUninstall;
@end

@interface UIView (AutoLayoutKit)

- (UIView *)commonSuperViewWithView:(UIView *)otherView;
@end