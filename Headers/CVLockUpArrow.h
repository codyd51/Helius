//
//  CVLockUpArrow.h
//  Convergance
//
//  Created by Matt Clarke on 12/07/2013.
//
//

#import <UIKit/UIKit.h>

@interface CVLockUpArrow : UIView <UIGestureRecognizerDelegate>

@property (readwrite, nonatomic) BOOL touchedRightPlace;
@property (nonatomic, retain) UIView *sliderUp;
@property (nonatomic, retain) UIImageView *up;
@property (nonatomic, retain) NSDate *lastTouchTime;
@property (readwrite) BOOL isDragging;

-(id)initWithFrame:(CGRect)frame;
-(void)bounce;

@end
