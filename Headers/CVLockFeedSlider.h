//
//  CVLockFeedSlider.h
//  Convergance
//
//  Created by Matt Clarke on 29/07/2013.
//
//

#import <UIKit/UIKit.h>
#import <Quartzcore/QuartzCore.h>

@interface CVLockFeedSlider : UIView <UIScrollViewDelegate> {
    CAGradientLayer *mask;
}

@property (nonatomic, strong) NSDate *lastTouchTime;
@property (nonatomic, strong) UIImageView *grabber;
@property (nonatomic, strong) UIScrollView *scroll;

-(void)loadWidgets;
-(void)unloadWidgets;
@end
