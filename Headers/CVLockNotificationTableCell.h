//
//  CVLockNotificationTableCell.h
//  Convergance
//
//  Created by Matt Clarke on 24/09/2013.
//
//

#import <UIKit/UIKit.h>

@interface CVLockNotificationTableCell : UITableViewCell <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scroll;
@property (retain, readwrite) UILabel *titleText;
@property (retain, readwrite) UILabel *messageText;
@property (retain, readwrite) UILabel *indicatorText;
@property (retain, readwrite) NSDate *bulletinDate;
@property (retain, readwrite) UILabel *dateText;
@property (retain, readwrite) UIView *line;
@property (retain, nonatomic, readwrite) UIImageView *highlight;
@property (retain, nonatomic, readwrite) UIImageView *bgView;
@property (weak) NSTimer *timer;
@property (readwrite) float height;

-(void)setNotificationValuesWithTitle:(NSString*)title message:(NSString*)message date:(NSDate*)date andReplyIndicator:(NSString*)indicator;

@end
