//
//  CVLockNotificationView.h
//  Convergance
//
//  Created by Matt Clarke on 15/09/2013.
//
//

#import <UIKit/UIKit.h>
#import "CVLockNotificationCell.h"

@class SBLockScreenNotificationListController;

@interface CVLockNotificationView : UICollectionViewController <UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
}

@property (nonatomic, retain) UIImageView *icon;
@property (nonatomic, retain) UITableView *notificationsTable;
@property (nonatomic, retain) UIButton *fullscrenNotifButton;
@property (nonatomic, retain) NSMutableArray *notificationArray;
@property (nonatomic, weak) SBLockScreenNotificationListController *notifListController;

-(void)setNotificationIconAlpha:(float)alpha;

-(void)removeNotificationAssetsIfNecessary;

@end
