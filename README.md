# BFScrollMenu
A UIViewController extension category that manipulate a view which associated with a scroll view.

### Demo

 ![image](https://github.com/wizardguy/screenshots/raw/master/BFScrollMenuDemo.gif)

### User case:
When you need a menu view do corresponding action when scrolling up or down the scrolling view (which mostly it is a table view), you can use UIViewController+BFScroll category to accomplish it. For example, if you want to hide the menu view when scrolling up and show it again when scrolling down.

### Usage:
It is very simple to use this category. Just setup it in your viewcontroller using corresponding blocks using the setting-up method:

	- (void)setUpDelegateClass:(Class _Nonnull)delegateClass
            	      MenuView:(UIView * _Nonnull )menuView
                conditionBlock:(BFConditionBlock _Nullable)condition
         	  scrollActionBlock:(BFActionBlock _Nullable)scrollAction
           		stopActionBlock:(BFActionBlock _Nullable)stopAction;

For example:

	// create your menu view ...
	self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 21, [UIScreen mainScreen].bounds.size.width, 80)];
	...
    
    // create your block ...
    BFActionBlock stop = ^(BFScrollingDirection lastDirection) {
        // ...
    };
    
    BFActionBlock scroll = ^(BFScrollingDirection lastDirection) {
        if (lastDirection == BFScrollingDirectionUP) {
            // animating hiding the menu view ... ;
        }
        else if (lastDirection == BFScrollingDirectionDown) {
            // animating showing the menu view ...
        }
    };
    
    // Set up
    [self setUpDelegateClass:[self class] MenuView:self.menuView conditionBlock:nil scrollActionBlock:scroll stopActionBlock:nil];

