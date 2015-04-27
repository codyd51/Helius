//
//  CVLockController.h
//  Convergance
//
//  Created by Matt Clarke on 11/07/2013.
//
//

#import <UIKit/UIKit.h>
#import "CVLockUpArrow.h"
#import "CVLockToggleController.h"
#import "CVLockFeedSlider.h"
#import "CVLockSlider.h"
#import "CVLockCameraOverlayView.h"
#import "CVLockTimeContainerView.h"
#import "CVLockBrightnessSlider.h"
#import "CVLockNotificationView.h"
#import "CVLockPasscodeView.h"
#import "CVLockSystemAlertWindow.h"
#import "CVLockHTMLBackgroundView.h"

@protocol SBUIBiometricEventObserver <NSObject>
@required
-(void)biometricEventMonitor:(id)arg1 handleBiometricEvent:(unsigned)arg2;
@end

@class CVLockController, CVLockNotificationView, CVLockTimeContainerView, PLCameraPageController, SBApplication, SBLockScreenCameraController, SBLockScreenViewController, SBUIBiometricEventMonitor, SBFProceduralWallpaperView;

#define TouchIDFingerDown  1
#define TouchIDFingerUp    0
#define TouchIDFingerHeld  2
#define TouchIDMatched     3
#define TouchIDNotMatched  9

@interface CVLockController : UIWindow <UIScrollViewDelegate, UIGestureRecognizerDelegate, SBUIBiometricEventObserver> {
    // These three will become properties soon
    NSTimer *timer;
    CVLockCameraOverlayView *cameraGestureOverlay;
    UIImageView *brightnessIcon;
    
    BOOL _wasMatching;
    id _monitorDelegate;
    BOOL isMonitoringEvents;
}

// Interface
@property (nonatomic, weak) UIImage *bgimage;
@property (nonatomic, retain) CVLockUpArrow *upArrow;
@property (nonatomic, retain) CVLockToggleController *toggles;
@property (nonatomic, retain) CVLockNotificationView *notificationView;
@property (nonatomic, retain) UIView *systemAlertAnimContainer;
@property (nonatomic, retain) UIImageView *batteryIcon;
@property (nonatomic, retain) UILabel *battPercent;
@property (nonatomic, retain) UIImageView *artwork;
@property (nonatomic, retain) CVLockSystemAlertWindow *sysAlrt;
@property (nonatomic, strong) UIImageView *leftArrow;
@property (nonatomic, strong) UIImageView *rightArrow;
@property (nonatomic, strong) CVLockSlider *slider;
@property (nonatomic, strong) CVLockFeedSlider *feedslider;
@property (nonatomic, strong) CVLockPasscodeView *passcodeView;
@property (nonatomic, strong) UIView *passcodeAnimationContainer;
@property (nonatomic, strong) UIImageView *defaultCamera;
@property (nonatomic, strong) UIView *camView;
@property (nonatomic, strong) CVLockTimeContainerView *timeMusicView;
@property (nonatomic, strong) UIImageView *blurredBackground;
@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) CVLockHTMLBackgroundView *bgHtml;
@property (nonatomic, strong) UIImageView *unlockui;
@property (nonatomic, strong) CVLockBrightnessSlider *brightness;

// iOS 7
@property (nonatomic, strong) SBLockScreenCameraController *camController;
@property (nonatomic, weak) SBLockScreenViewController *sbVc;
@property (nonatomic, strong) SBFProceduralWallpaperView *dynamicWallpaper;

// Backends
@property (nonatomic) BOOL noUnlockYet;
@property (nonatomic) BOOL fromToggles;
@property (nonatomic) float aimedSliderContentOffset;
@property (readwrite) BOOL isPasscodeSet;
@property (readwrite) BOOL retreiveNewCamera;
@property (readwrite) BOOL allowSnoozeAlert;
@property (nonatomic, strong) NSTimer *passcodeTimer;
@property (nonatomic, strong) NSTimer *batterytimer;
@property (nonatomic) float alphalevel;


// Interface
-(id)init;
-(void)insertPasscodeView:(id)sender;
-(void)didRecieveNewNotificationWithBulletin:(id)bulletin;
-(void)setNotificationsAlpha:(float)alpha;
-(UIImage*)snapshotForTopmostApplication;
-(UIImage*)imageForApplication:(SBApplication*)application isNotificationOpening:(BOOL)notif;
-(void)throwUpBufferWindowForApplication:(SBApplication*)application isNotificationOpening:(BOOL)notif;
-(void)refreshUnlockuiView;
-(void)tearDownUi;
-(void)_noteSystemAlertWasHidden:(CVLockSystemAlertWindow*)alertView;
    -(void)hideCameraView;
-(void)returnCameraToCenter:(BOOL)anim;
-(void)tearDownCamera;
-(void)tearDownCameraOverlay;
-(void)addPreCamView;
-(void)showMusicView;
-(void)showTimeView;
-(void)updateDate;

// Backends
+(void)setInCenter:(BOOL)val;
+(BOOL)getInCenter;
+(void)setInCamera:(BOOL)val;
+(BOOL)getInCamera;
+(void)setInToggles:(BOOL)val;
+(BOOL)getInToggles;
+(void)setOrigOffsetX:(float)val;
-(void)batteryStateChanged:(NSNotification*)notification;
-(void)batteryLevelChanged:(NSTimer*)timer;
-(void)changedNowPlayingItem;
-(BOOL)requiresUpdateToMusicInfo;

@end
