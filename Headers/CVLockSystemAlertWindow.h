//
//  CVLockSystemAlertWindow.h
//  Convergance
//
//  Created by Matt Clarke on 18/10/2013.
//
//

#import <UIKit/UIKit.h>

@class SBSystemLocalNotificationAlert, SBAwaySystemAlertItem, SBLockScreenSystemAlertFullscreenViewController;

@interface CVLockSystemAlertWindow : UIView

@property (nonatomic, retain) SBAwaySystemAlertItem *alert;
@property (nonatomic, retain) SBLockScreenSystemAlertFullscreenViewController *localNotifController;

-(id)initWithAwaySystemAlert:(SBAwaySystemAlertItem*)alertItm;
-(id)initWithLocalSystemNotificationController:(SBLockScreenSystemAlertFullscreenViewController*)alrt title:(NSString*)titleTxt;
-(void)hide;

@end
