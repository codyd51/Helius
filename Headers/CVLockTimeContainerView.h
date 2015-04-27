//
//  CVLockTimeContainerView.h
//  Convergance
//
//  Created by Matt Clarke on 09/09/2013.
//
//

#import <UIKit/UIKit.h>
#import "CVResources.h"
#import "CVLockController.h"

@class CVReactiveButton;

@interface CVLockTimeContainerView : UIView

@property (nonatomic, retain) UIView *timeContainer;
@property (nonatomic, retain) UIView *musicContainer;
@property (nonatomic, retain) UILabel *date;
@property (nonatomic, retain) UILabel *time;
@property (nonatomic, retain) NSTimer *timeUpdater;
@property (nonatomic, retain) CVReactiveButton *play;
@property (nonatomic, retain) CVReactiveButton *forward;
@property (nonatomic, retain) CVReactiveButton *rewind;
@property (nonatomic, retain) UILabel *artist;
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UIImageView *artwork;
@property (readwrite) BOOL requiresUpdateToInfo;
@property (nonatomic, strong) NSTimer *retryTitles;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, readwrite) BOOL dontShowDate;
@property (nonatomic, strong) UIProgressView *battery;

-(void)updateDate;
-(void)updateDateWithBattery:(BOOL)arg1;
-(BOOL)timeIs24HourFormat;

-(void)showMusicView;
-(void)showTimeView;

-(void)changedPlaybackState:(BOOL)playing;
-(void)changedNowPlayingItem;

@end
