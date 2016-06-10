//
//  UIViewController+BFScroll.m
//
//  Created by wizardguy(Bigfeet) on 5/6/2016.
//  Copyright © 2016 Dennis. All rights reserved.
//
//  GitHub: https://github.com/wizardguy/BFScrollMenu
//

#import "UIViewController+BFScroll.h"
#import <objc/runtime.h>



@implementation UIViewController (BFScroll)

#pragma mark - properties
static const char BFConditionBlockKey = '\0';
- (void)setConditionBlock:(BFConditionBlock)conditionBlock
{
    if (conditionBlock != self.conditionBlock) {
        self.conditionBlock = nil;
        objc_setAssociatedObject(self, &BFConditionBlockKey, conditionBlock, OBJC_ASSOCIATION_COPY);
    }
}

- (BFConditionBlock)conditionBlock
{
    return objc_getAssociatedObject(self, &BFConditionBlockKey);
}


static const char BFMenuViewKey = '\0';
- (void)setMenuView:(__kindof UIView *)menuView
{
    if (menuView != self.menuView) {
        self.menuView = nil;
        objc_setAssociatedObject(self, &BFMenuViewKey, menuView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (__kindof UIView *)menuView
{
    return objc_getAssociatedObject(self, &BFMenuViewKey);
}


static const char BFScrollActionBlockKey = '\0';
- (void)setScrollActionBlock:(BFActionBlock)scrollActionBlock
{
    if (scrollActionBlock != self.scrollActionBlock) {
        self.scrollActionBlock = nil;
        objc_setAssociatedObject(self, &BFScrollActionBlockKey, scrollActionBlock, OBJC_ASSOCIATION_COPY);
    }
}

- (BFActionBlock)scrollActionBlock
{
    return objc_getAssociatedObject(self, &BFScrollActionBlockKey);
}


static const char BFStopActionBlockKey = '\0';
- (void)setStopActionBlock:(BFActionBlock)stopActionBlock
{
    if (stopActionBlock != self.stopActionBlock) {
        self.stopActionBlock = nil;
        objc_setAssociatedObject(self, &BFStopActionBlockKey, stopActionBlock, OBJC_ASSOCIATION_COPY);
    }
}

- (BFActionBlock)stopActionBlock
{
    return objc_getAssociatedObject(self, &BFStopActionBlockKey);
}


static const char BFViewStateKey = '\0';
- (void) setViewState:(BFMenuViewState)viewState
{
    objc_setAssociatedObject(self, &BFViewStateKey, [NSNumber numberWithInt:viewState], OBJC_ASSOCIATION_ASSIGN);
}

- (BFMenuViewState)viewState
{
    id val = objc_getAssociatedObject(self, &BFViewStateKey);
    return (val == nil) ? 0 : [(NSNumber *)val intValue];
}


static const char BFLastDirectionKey = '\0';
- (void)setLastDirection:(BFScrollingDirection)lastDirection
{
    objc_setAssociatedObject(self, &BFLastDirectionKey, [NSNumber numberWithInt:lastDirection], OBJC_ASSOCIATION_ASSIGN);
}

- (BFScrollingDirection)lastDirection
{
    id val = objc_getAssociatedObject(self, &BFLastDirectionKey);
    return (val == nil) ? 0 : [(NSNumber *)val intValue];
}


static const char BFScrollingSensitivityKey = '\0';
- (void)setScrollingSensitivity:(int)scrollingSensitivity
{
    objc_setAssociatedObject(self, &BFScrollingSensitivityKey, [NSNumber numberWithInt:scrollingSensitivity], OBJC_ASSOCIATION_ASSIGN);
}

- (int)scrollingSensitivity
{
    id val = objc_getAssociatedObject(self, &BFScrollingSensitivityKey);
    return (val == nil) ? 0 : [(NSNumber *)val intValue];
}



static const char BFLastPostionKey = '\0';
- (void)setLastPosition:(int)lastPosition
{
    objc_setAssociatedObject(self, &BFLastPostionKey, [NSNumber numberWithInt:lastPosition], OBJC_ASSOCIATION_ASSIGN);
}

- (int)lastPosition
{
    id val = objc_getAssociatedObject(self, &BFLastPostionKey);
    return (val == nil) ? 0 : [(NSNumber *)val intValue];
}


#pragma mark - methods
- (void)setUpDelegateClass:(Class)delegateClass
                  MenuView:(UIView *)menuView
            conditionBlock:(BFConditionBlock)condition
         scrollActionBlock:(BFActionBlock)scrollAction
           stopActionBlock:(BFActionBlock)stopAction
{
    self.menuView = menuView;
    self.conditionBlock = condition;
    self.scrollActionBlock = scrollAction;
    self.stopActionBlock = stopAction;
    self.lastDirection = BFScrollingDirectionStill;
    self.viewState = BFMenuViewStateUnknown;
    self.lastPosition = 0;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(delegateClass, @selector(scrollViewDidScroll:)), class_getInstanceMethod([self class], @selector(BFScrollViewDidScroll:)));
        if (self.stopActionBlock) {
            method_exchangeImplementations(class_getInstanceMethod(delegateClass, @selector(scrollViewDidEndDecelerating:)), class_getInstanceMethod([self class], @selector(BFScrollViewDidEndDecelerating:)));
        }
    });
}



- (void)actionWithBlock:(BFActionBlock)block
{
    if (block) {
        // if state changes
        BFMenuViewState currentState = (BFMenuViewState)self.lastDirection;
        if (self.viewState != currentState) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // if condition matches
                if ((self.conditionBlock && self.conditionBlock(self.lastDirection, self.lastPosition)) || self.conditionBlock == nil) {
                    // do the action
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(self.lastDirection);
                        self.viewState = currentState;
                    });
                }
            });
        }
    }
}


- (void)BFScrollViewDidScroll:(UIScrollView *)scrollView
{
    [self BFScrollViewDidScroll:scrollView];
    int currentPosition = scrollView.contentOffset.y;
    
    BFScrollingDirection direction = self.lastDirection;
    if (!scrollView.decelerating) {
        int delta = currentPosition - self.lastPosition;
        // Scrolling Up
        if (delta > self.scrollingSensitivity) {
            direction = BFScrollingDirectionUP;
        }
        // Scrolling Down
        else if (delta < 0 && -delta > self.scrollingSensitivity) {
            direction = BFScrollingDirectionDown;
            delta = -delta;
        }
    }
    direction != BFScrollingDirectionStill ? self.lastDirection = direction : NO;
    self.lastPosition = currentPosition;
    
    [self actionWithBlock:self.scrollActionBlock];
}


- (void)BFScrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self BFScrollViewDidEndDecelerating:scrollView];
    
    [self actionWithBlock:self.stopActionBlock];
}


@end
