//
//  CVLockFeedWidgetBackground.h
//  Convergance
//
//  Created by Matt Clarke on 20/02/2014.
//
// *** Please note that I'm not actually using this yet for the widget backgrounds ***

#import <UIKit/UIKit.h>

@interface CVLockFeedWidgetBackground : UIView {
    UIImageView *_blur;
}

-(void)changeBackground:(UIImage*)background;

@end
