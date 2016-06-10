//
//  UIViewController+BFScroll.h
//
//  Created by wizardguy(Bigfeet) on 5/6/2016.
//  Copyright © 2016 Dennis. All rights reserved.
//
//  GitHub: https://github.com/wizardguy/BFScrollMenu
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BFScrollingDirection) {
    BFScrollingDirectionStill = 0,
    BFScrollingDirectionUP = 1,
    BFScrollingDirectionDown = 2
};


typedef NS_ENUM(NSInteger, BFMenuViewState) {
    BFMenuViewStateUnknown = 0,
    BFMenuViewStateUp = 1,
    BFMenuViewStateDown = 2
};


typedef BOOL(^BFConditionBlock)(BFScrollingDirection direction, int currentPosition);
typedef void(^BFActionBlock)(BFScrollingDirection direction);


@interface UIViewController (BFScroll)

// The menu view you would like to manipulate
@property (strong, nonatomic, readwrite, nullable) __kindof UIView *menuView;

// A block that calculates the pre-condition of doing the action. Will be ignored if set to nil.
@property (strong, readwrite, nullable) BFConditionBlock conditionBlock;
// A block that does the action when scrolling. Will be ignored if set to nil.
@property (strong, readwrite, nullable) BFActionBlock scrollActionBlock;
// A block that does the action when scrolling is ended. Will be ignored if set to nil.
@property (strong, readwrite, nullable) BFActionBlock stopActionBlock;

// current menu view state
// discussion: The view state is corresponding to the scrolling direction.
//             In this context, state would only be 'Up' or 'Down'
@property (assign, readwrite, atomic) BFMenuViewState viewState;

// current/last scrolling direction
@property (assign, readwrite, atomic) BFScrollingDirection lastDirection;

// action will not trigger if scrolling delta is less than the 'sensitivity'
@property (assign, readwrite) int scrollingSensitivity;

// the last position the view scrolling to
@property (assign, readwrite) int lastPosition;

// param: delegateClass - the class that is delegate of the scrolling, a.k.a, implemeting the scrolling delegate methods like scrollViewDidScroll:.
- (void)setUpDelegateClass:(Class _Nonnull)delegateClass
                  MenuView:(UIView * _Nonnull )menuView
            conditionBlock:(BFConditionBlock _Nullable)condition
         scrollActionBlock:(BFActionBlock _Nullable)scrollAction
           stopActionBlock:(BFActionBlock _Nullable)stopAction;

@end
