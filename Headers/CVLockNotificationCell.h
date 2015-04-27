//
//  CVLockNotificationCell.h
//  Convergance
//
//  Created by Matt Clarke on 16/09/2013.
//
//

#import <UIKit/UIKit.h>
#import "CVLockController.h"

@interface CVLockNotificationCell : UICollectionViewCell

@property (nonatomic, retain) UILabel *count;
@property (nonatomic, retain) UIImageView *bulletinImage;
@property (nonatomic, retain) NSString *bundleId;
@property (readwrite) int currentValue;

//-(void)initWithBulletin:(SBAwayBulletinListItem*)bulletin;
-(void)incrementNotificationCount:(int)newcount;

@end
