#import "_NowPlayingArtView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPVolumeSlider.h>
#import	<MediaPlayer/MPVolumeView.h>
#import "PrivateHeaders.h"
#import "BlurImage.xm"
#import "UIImageAverageColorAddition.m"
#import "UIImageCropRect.m"
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "PrivateHeaders.h"
#import "SBBlurryArtworkView.h"
#import "Headers/Convergance.h"
#import "substrate.h"
#include <dlfcn.h>
int height = [[UIScreen mainScreen] bounds].size.height;
NS_INLINE CGFloat calculateHeight(CGFloat percent) { return percent * height; }

#define _NSC_ [NSNotificationCenter defaultCenter]
#define register_for_nsnotifications_on_object(_name, _object, observer, callback) [_NSC_ addObserver:observer selector:callback name:_name object:_object]
#define isPlayingMusic (MPMusicPlayerController.iPodMusicPlayer.playbackState == MPMusicPlaybackStatePlaying)
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height == 568.0f)

@interface SpringBoard
-(CVLockController*)converganceLs;
@end

NSMutableDictionary *prefs;
BOOL debug;
BOOL upwardCompatible;
BOOL enabled;
BOOL crossfade;
BOOL blurBack;
BOOL isPirated;
int crossfadeDuration;
UIImage* croppedImage = [[UIImage alloc] init];
UILabel* clockLabel = [[UILabel alloc] init];
UILabel* titleLabel = [[UILabel alloc] init];
UILabel* authorLabel = [[UILabel alloc] init];
UILabel* albumLabel = [[UILabel alloc] init];
UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
UIImage *backImage = [[UIImage alloc] init];
UIImage *maskImage = [[UIImage alloc] init];
UIImage* lightColor = [[UIImage alloc] init];
UIImageView* overImage = [[UIImageView alloc] init];
UIColor* color = [[UIColor alloc] init];
UIImage* darkArt = [[UIImage alloc] init];
UIImageView* currentAlbumArt = [[UIImageView alloc] init];
UIImageView* newImage = [[UIImageView alloc] init];
MPVolumeView *volumeViewSlider = [[MPVolumeView alloc] init];
//MPUSystemMediaControlsViewController* progressView = [[MPUSystemMediaControlsViewController alloc] init];
NSTimer* songScrubTimer = [[NSTimer alloc] init];
UIView* window = [[UIView alloc] init];
static UIView* wind = [[UIView alloc] init];
static SBBlurryArtworkView *_blurryArtworkView = nil;
static NSDictionary *_preferences = nil;
static NSData *_artworkData;
SBLockScreenScrollView* newScroll;

@interface MPVolumeView ()
@property(nonatomic) BOOL showsRouteButton;
- (void)setVolumeThumbImage:(UIImage *)image forState:(UIControlState)state;
@end

@interface MAMusicArtController : NSObject
+ (instancetype)sharedInstance;
- (void)nowPlayingItemDidChange:(id)notification;
- (void)playbackStateDidChange:(id)notification;
@end
@implementation MAMusicArtController
+ (instancetype)sharedInstance {
	static id instance;
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		instance = [[MAMusicArtController alloc] init];
	});
	return instance;
}
- (void)nowPlayingItemDidChange:(id)notification {
	if (enabled && !isPirated) {
	if (debug) NSLog(@"Helius--nowPlayingItemDidChange");
	UpdateArt* art = [[UpdateArt alloc] init];
	color = [art updateAlbumColor:color];
	overImage = [art updateOverImage];
	[art checkColorOfTitle:titleLabel andAuthor:authorLabel andAlbum:albumLabel];
	playButton = [art updatePlayButton:playButton];
	if (crossfade) {
	//currentAlbumArt.image = [art updateAlbumArt:currentAlbumArt.image andSize:CGSizeMake(160, 279.1)];
	[UIView transitionWithView:currentAlbumArt
					  duration:crossfadeDuration
					   options:UIViewAnimationOptionTransitionCrossDissolve
				   animations:^{
								   currentAlbumArt.image = [art updateAlbumArt:currentAlbumArt.image andSize:CGSizeMake(160, 279.1)];
							   }
				   completion:nil];
	//darkArt = [art updateAlbumArt:darkArt andSize:CGSizeMake(225, 225)];
	[UIView transitionWithView:newImage
					  duration:crossfadeDuration
					   options:UIViewAnimationOptionTransitionCrossDissolve
				   animations:^{
								   darkArt = [art updateAlbumArt:darkArt andSize:CGSizeMake(225, 225)];
							   }
				   completion:nil];
	color = [art updateAlbumColor:color];
	//backImage = [art updateBackImage:backImage];
	[UIView transitionWithView:newImage
					  duration:crossfadeDuration
					   options:UIViewAnimationOptionTransitionCrossDissolve
				   animations:^{
								   backImage = [art updateBackImage:backImage];
							   }
				   completion:nil];
	//lightColor = [art updateLightColor:lightColor];
	[UIView transitionWithView:newImage
					  duration:crossfadeDuration
					   options:UIViewAnimationOptionTransitionCrossDissolve
				   animations:^{
								   lightColor = [art updateLightColor:lightColor];
							   }
				   completion:nil];
	//newImage = [art updateNewImage];
	[UIView transitionWithView:newImage
					  duration:crossfadeDuration
					   options:UIViewAnimationOptionTransitionCrossDissolve
				   animations:^{
								   newImage = [art updateNewImage];
							   }
				   completion:nil];
	overImage = [art updateOverImage];
	[UIView transitionWithView:overImage
					  duration:crossfadeDuration
					   options:UIViewAnimationOptionTransitionCrossDissolve
				   animations:^{
								   overImage = [art updateOverImage];
							   }
				   completion:nil];
	//authorLabel.text = [art updateAuthorLabel];
	[UIView transitionWithView:authorLabel
					  duration:crossfadeDuration
					   options:UIViewAnimationOptionTransitionCrossDissolve
				   animations:^{
								   authorLabel.text = [art updateAuthorLabel];
							   }
				   completion:nil];
	[art checkColorOfTitle:titleLabel andAuthor:authorLabel andAlbum:albumLabel];
	//titleLabel.text = [art updateTitleLabel];
	[UIView transitionWithView:titleLabel
					  duration:crossfadeDuration
					   options:UIViewAnimationOptionTransitionCrossDissolve
				   animations:^{
								   titleLabel.text = [art updateTitleLabel];
							   }
				   completion:nil];
	//albumLabel.text = [art updateAlbumLabel];
	[UIView transitionWithView:albumLabel
					  duration:crossfadeDuration
					   options:UIViewAnimationOptionTransitionCrossDissolve
				   animations:^{
								   albumLabel.text = [art updateAlbumLabel];
							   }
				   completion:nil];
	//volumeViewSlider = [art updateSliderTint:volumeViewSlider];
	[UIView transitionWithView:newImage
					  duration:crossfadeDuration
					   options:UIViewAnimationOptionTransitionCrossDissolve
				   animations:^{
								   volumeViewSlider = [art updateSliderTint:volumeViewSlider];
							   }
				   completion:nil];
	[art checkColorOfTitle:titleLabel andAuthor:authorLabel andAlbum:albumLabel];
	playButton = [art updatePlayButton:playButton];
	}
	else {
		currentAlbumArt.image = [art updateAlbumArt:currentAlbumArt.image andSize:CGSizeMake(160, 279.1)];
		darkArt = [art updateAlbumArt:darkArt andSize:CGSizeMake(225, 225)];
		color = [art updateAlbumColor:color];
		backImage = [art updateBackImage:backImage];
		lightColor = [art updateLightColor:lightColor];
		newImage = [art updateNewImage];
		overImage = [art updateOverImage];
		authorLabel.text = [art updateAuthorLabel];
		[art checkColorOfTitle:titleLabel andAuthor:authorLabel andAlbum:albumLabel];
		titleLabel.text = [art updateTitleLabel];
		albumLabel.text = [art updateAlbumLabel];
		volumeViewSlider = [art updateSliderTint:volumeViewSlider];
		[art checkColorOfTitle:titleLabel andAuthor:authorLabel andAlbum:albumLabel];
		playButton = [art updatePlayButton:playButton];
	}
	color = [art updateAlbumColor:color];
	overImage = [art updateOverImage];
	[art checkColorOfTitle:titleLabel andAuthor:authorLabel andAlbum:albumLabel];
	playButton = [art updatePlayButton:playButton];
	}
}
- (void)playbackStateDidChange:(id)notification {
	if (enabled && !isPirated) {
	if (debug) NSLog(@"Helius--playbackStateDidChange");
	UpdateArt* art = [[UpdateArt alloc] init];
	playButton = [art updatePlayButton:playButton];
	}
}
@end

%group Main

//convergance support
%hook SBLockScreenManager

-(void)lockUIFromSource:(int)arg1 withOptions:(id)arg2 {

	%orig;
/*
	CVLockController *conv = [(SpringBoard*)[UIApplication sharedApplication] converganceLs];
	CVLockController*conv = [objc_getClass("CVAPI") mainWindow];
	UIView* controlsContainer = conv.timeMusicView.musicContainer;

	for (UIView* view in controlsContainer.subviews) {
		[view removeFromSuperview];
	}

	controlsContainer.clipsToBounds = NO;

	[controlsContainer addSubview:newImage];
	[controlsContainer addSubview:overImage];
	[controlsContainer addSubview:clockLabel];
	[controlsContainer addSubview:titleLabel];
	[controlsContainer addSubview:authorLabel];
	[controlsContainer addSubview:albumLabel];
	[controlsContainer addSubview:playButton];
	[controlsContainer addSubview:backButton];
	[controlsContainer addSubview:nextButton];
	[controlsContainer addSubview:currentAlbumArt];
	[controlsContainer addSubview:volumeViewSlider];
*/
}

%end

%hook SBLockScreenNowPlayingPluginController

- (BOOL)isNowPlayingPluginActive {
	BOOL check = %orig;
	if (enabled && !isPirated) {
	if (check) {
		if (debug) NSLog(@"Helius--check TRUE");
	}
	else if (!check) {
		if (debug) NSLog(@"Helius--check FALSE");
		/*
		[clockLabel removeFromSuperview];
		[newImage removeFromSuperview];
		[overImage removeFromSuperview];
		[titleLabel removeFromSuperview];
		[authorLabel removeFromSuperview];
		[albumLabel removeFromSuperview];
		[playButton removeFromSuperview];
		[backButton removeFromSuperview];
		[nextButton removeFromSuperview];
		[currentAlbumArt removeFromSuperview];
		[volumeViewSlider removeFromSuperview];
		[_blurryArtworkView removeFromSuperview];
		*/
		//[progressView removeFromSuperview];
		//[window removeGestureRecognizer:tapRecognizer];
	}
	}
	return check;
}

%end

%hook SBLockScreenNotificationListController

- (void)observer:(id)arg1 addBulletin:(id)bulletin forFeed:(unsigned long long)arg3 {
	%orig;
	if (enabled && !isPirated) {
		[clockLabel removeFromSuperview];
		[newImage removeFromSuperview];
		[overImage removeFromSuperview];
		[titleLabel removeFromSuperview];
		[authorLabel removeFromSuperview];
		[albumLabel removeFromSuperview];
		[playButton removeFromSuperview];
		[backButton removeFromSuperview];
		[nextButton removeFromSuperview];
		[currentAlbumArt removeFromSuperview];
		[volumeViewSlider removeFromSuperview];
		[_blurryArtworkView removeFromSuperview];
	}
}

%end

%hook SBLockScreenNotificationListView

- (void)layoutSubviews {
	%orig;
	if (enabled && !isPirated) {
		[clockLabel removeFromSuperview];
		[newImage removeFromSuperview];
		[overImage removeFromSuperview];
		[titleLabel removeFromSuperview];
		[authorLabel removeFromSuperview];
		[albumLabel removeFromSuperview];
		[playButton removeFromSuperview];
		[backButton removeFromSuperview];
		[nextButton removeFromSuperview];
		[currentAlbumArt removeFromSuperview];
		[volumeViewSlider removeFromSuperview];
		[_blurryArtworkView removeFromSuperview];
	}
}

%end

%hook SBLockScreenView

-(void)setCustomSlideToUnlockText:(id)arg1 {
	if (upwardCompatible && !isPirated) {
	if (enabled && isPlayingMusic && upwardCompatible && !isPirated) {

		SBLockScreenViewController* lockViewController = MSHookIvar<SBLockScreenViewController*>([%c(SBLockScreenManager) sharedInstance], "_lockScreenViewController");
		SBLockScreenView* lockView = MSHookIvar<SBLockScreenView*>(lockViewController, "_view");
		newScroll = MSHookIvar<SBLockScreenScrollView*>(lockView, "_foregroundScrollView");

		float width = UIScreen.mainScreen.bounds.size.width;

		if (debug) NSLog(@"Helius--isPlayingMusic glintyAnimationDidStart");
		UpdateArt* art = [[UpdateArt alloc] init];

		[clockLabel removeFromSuperview];
		[newImage removeFromSuperview];
		[overImage removeFromSuperview];
		[titleLabel removeFromSuperview];
		[authorLabel removeFromSuperview];
		[albumLabel removeFromSuperview];
		[playButton removeFromSuperview];
		[backButton removeFromSuperview];
		[nextButton removeFromSuperview];
		[currentAlbumArt removeFromSuperview];
		[volumeViewSlider removeFromSuperview];

		wind = MSHookIvar<UIView *>(self, "_foregroundView");
		NSDateFormatter* DateFormatter=[[NSDateFormatter alloc] init];
		[DateFormatter setDateFormat:@"hh:mm"];
		if (debug) NSLog(@"Helius--%@",[DateFormatter stringFromDate:[NSDate date]]);

		clockLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:60];
		clockLabel.adjustsFontSizeToFitWidth = YES;
		[clockLabel setTextColor:[UIColor whiteColor]];
		clockLabel.numberOfLines = 1;
		[clockLabel setCenter:newScroll.center];
		clockLabel.textAlignment = NSTextAlignmentCenter;
		clockLabel.text = [NSString stringWithFormat:@"%@", [DateFormatter stringFromDate:[NSDate date]]];
		clockLabel.frame = CGRectMake(0, 0, 320, height);
		clockLabel.center = CGPointMake(newScroll.center.x+width, calculateHeight(.112676056));

		playButton = [[UIButton alloc] init];
		nextButton = [[UIButton alloc] init];
		backButton = [[UIButton alloc] init];

		playButton = [UIButton buttonWithType:UIButtonTypeCustom];
		backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		nextButton = [UIButton buttonWithType:UIButtonTypeCustom];

		[playButton addTarget:self action:@selector(touchedPlayButton:) forControlEvents:UIControlEventTouchUpInside];
		[playButton setImage:[UIImage imageNamed:@"SystemMediaControl-Pause-StarkNowPlaying" inBundle:[NSBundle bundleWithIdentifier:@"com.apple.MediaPlayerUI"]] forState:UIControlStateNormal];
		playButton.frame = CGRectMake(0, 0, 17.5, calculateHeight(.030809859));
		playButton.center = CGPointMake(160+width, calculateHeight(.774647887));

		[backButton addTarget:self action:@selector(touchedBackButton:) forControlEvents:UIControlEventTouchUpInside];
		[backButton setImage:[UIImage imageNamed:@"SystemMediaControl-Rewind-StarkNowPlaying" inBundle:[NSBundle bundleWithIdentifier:@"com.apple.MediaPlayerUI"]] forState:UIControlStateNormal];
		backButton.frame = CGRectMake(0, 0, 25, calculateHeight(.039612676));
		backButton.center = CGPointMake(90+width, calculateHeight(.774647887));

		[nextButton addTarget:self action:@selector(touchedNextButton:) forControlEvents:UIControlEventTouchUpInside];
		[nextButton setImage:[UIImage imageNamed:@"SystemMediaControl-Forward-StarkNowPlaying" inBundle:[NSBundle bundleWithIdentifier:@"com.apple.MediaPlayerUI"]] forState:UIControlStateNormal];
		nextButton.frame = CGRectMake(0, 0, 25, calculateHeight(.039612676));
		nextButton.center = CGPointMake(230+width, calculateHeight(.774647887));

		currentAlbumArt.frame = CGRectMake(0, 0, 200, calculateHeight(.352112676));
		currentAlbumArt.center = CGPointMake(160+width, calculateHeight(.491373239));

		newImage.frame = CGRectMake(0, 0, 225, calculateHeight(.396126761));
		overImage.frame = CGRectMake(0, 0, 225, calculateHeight(.616197183));

		[newImage cutHoleInImageView:newImage withSize:CGRectMake(12.5, 12.5, 200, calculateHeight(.352112676))];
		[overImage cutHoleInImageView:overImage withSize:CGRectMake(0, 52.5, 237.5, calculateHeight(.396126761))];

		CALayer* roundedLayer = [overImage layer];
		[roundedLayer setMasksToBounds:YES];
		[roundedLayer setCornerRadius:20.0];

		newImage.center = CGPointMake(160+width, calculateHeight(.491197183));
		newImage.alpha = 0.5;

		overImage.center = CGPointMake(160+width, calculateHeight(.508802817));

		authorLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLightItalic" size:10];
		authorLabel.adjustsFontSizeToFitWidth = YES;
		authorLabel.numberOfLines = 1;
		[authorLabel setCenter:newScroll.center];
		authorLabel.textAlignment = NSTextAlignmentCenter;
		authorLabel.frame = CGRectMake(0, 0, 220, height);
		authorLabel.center = CGPointMake(newScroll.center.x+width, calculateHeight(.218309859));

		titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
		titleLabel.adjustsFontSizeToFitWidth = YES;
		titleLabel.numberOfLines = 1;
		[titleLabel setCenter:newScroll.center];
		titleLabel.textAlignment = NSTextAlignmentCenter;
		titleLabel.frame = CGRectMake(0, 0, 220, height);
		titleLabel.center = CGPointMake(newScroll.center.x+width, calculateHeight(.244288225));

		albumLabel.font = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:10];
		albumLabel.adjustsFontSizeToFitWidth = YES;
		albumLabel.numberOfLines = 1;
		[albumLabel setCenter:newScroll.center];
		albumLabel.textAlignment = NSTextAlignmentCenter;
		albumLabel.frame = CGRectMake(0, 0, 220, height);
		albumLabel.center = CGPointMake(newScroll.center.x+width, calculateHeight(.275528169));

		[art checkColorOfTitle:titleLabel andAuthor:authorLabel andAlbum:albumLabel];

		volumeViewSlider.frame = CGRectMake(0, 0, 180, calculateHeight(.088028169));
		volumeViewSlider.center = CGPointMake(160+width, calculateHeight(.748239437));
		volumeViewSlider.showsRouteButton = NO;
		[volumeViewSlider setVolumeThumbImage:[UIImage imageNamed:@"ControlCenterSliderThumb" inBundle:[NSBundle bundleWithIdentifier:@"com.apple.SpringBoardUIFramework"]] forState:UIControlStateNormal];
		[volumeViewSlider sizeToFit];
		volumeViewSlider = [art updateSliderTint:volumeViewSlider];

		songScrubTimer = [NSTimer timerWithTimeInterval:1 target:art selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
		if ([songScrubTimer isValid]) NSLog(@"Helius--Timer IS VALID");
		if (![songScrubTimer isValid]) [songScrubTimer fire];

		[newScroll addSubview:newImage];
		[newScroll addSubview:overImage];
		[newScroll addSubview:clockLabel];
		[newScroll addSubview:titleLabel];
		[newScroll addSubview:authorLabel];
		[newScroll addSubview:albumLabel];
		[newScroll addSubview:playButton];
		[newScroll addSubview:backButton];
		[newScroll addSubview:nextButton];
		[newScroll addSubview:currentAlbumArt];
		[newScroll addSubview:volumeViewSlider];

	}
	else {
		if (enabled && !isPirated) {
		[newImage removeFromSuperview];
		[overImage removeFromSuperview];
		[clockLabel removeFromSuperview];
		[titleLabel removeFromSuperview];
		[authorLabel removeFromSuperview];
		[albumLabel removeFromSuperview];
		[playButton removeFromSuperview];
		[backButton removeFromSuperview];
		[nextButton removeFromSuperview];
		[currentAlbumArt removeFromSuperview];
		[volumeViewSlider removeFromSuperview];
		[_blurryArtworkView removeFromSuperview];
		}
	}
	}
	%orig;
}

- (void)glintyAnimationDidStart {

	if (enabled && isPlayingMusic && !isPirated) {

		SBLockScreenViewController* lockViewController = MSHookIvar<SBLockScreenViewController*>([%c(SBLockScreenManager) sharedInstance], "_lockScreenViewController");
		SBLockScreenView* lockView = MSHookIvar<SBLockScreenView*>(lockViewController, "_view");
		newScroll = MSHookIvar<SBLockScreenScrollView*>(lockView, "_foregroundScrollView");

		float width = UIScreen.mainScreen.bounds.size.width;

		if (debug) NSLog(@"Helius--isPlayingMusic glintyAnimationDidStart");
		UpdateArt* art = [[UpdateArt alloc] init];

		[clockLabel removeFromSuperview];
		[newImage removeFromSuperview];
		[overImage removeFromSuperview];
		[titleLabel removeFromSuperview];
		[authorLabel removeFromSuperview];
		[albumLabel removeFromSuperview];
		[playButton removeFromSuperview];
		[backButton removeFromSuperview];
		[nextButton removeFromSuperview];
		[currentAlbumArt removeFromSuperview];
		[volumeViewSlider removeFromSuperview];

		wind = MSHookIvar<UIView *>(self, "_foregroundView");
		NSDateFormatter* DateFormatter=[[NSDateFormatter alloc] init];
		[DateFormatter setDateFormat:@"hh:mm"];
		if (debug) NSLog(@"Helius--%@",[DateFormatter stringFromDate:[NSDate date]]);

		clockLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:60];
		clockLabel.adjustsFontSizeToFitWidth = YES;
		[clockLabel setTextColor:[UIColor whiteColor]];
		clockLabel.numberOfLines = 1;
		[clockLabel setCenter:newScroll.center];
		clockLabel.textAlignment = NSTextAlignmentCenter;
		clockLabel.text = [NSString stringWithFormat:@"%@", [DateFormatter stringFromDate:[NSDate date]]];
		clockLabel.frame = CGRectMake(0, 0, 320, height);
		clockLabel.center = CGPointMake(newScroll.center.x+width, calculateHeight(.112676056));

		playButton = [[UIButton alloc] init];
		nextButton = [[UIButton alloc] init];
		backButton = [[UIButton alloc] init];

		playButton = [UIButton buttonWithType:UIButtonTypeCustom];
		backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		nextButton = [UIButton buttonWithType:UIButtonTypeCustom];

		[playButton addTarget:self action:@selector(touchedPlayButton:) forControlEvents:UIControlEventTouchUpInside];
		[playButton setImage:[UIImage imageNamed:@"SystemMediaControl-Pause-StarkNowPlaying" inBundle:[NSBundle bundleWithIdentifier:@"com.apple.MediaPlayerUI"]] forState:UIControlStateNormal];
		playButton.frame = CGRectMake(0, 0, 17.5, calculateHeight(.030809859));
		playButton.center = CGPointMake(160+width, calculateHeight(.774647887));

		[backButton addTarget:self action:@selector(touchedBackButton:) forControlEvents:UIControlEventTouchUpInside];
		[backButton setImage:[UIImage imageNamed:@"SystemMediaControl-Rewind-StarkNowPlaying" inBundle:[NSBundle bundleWithIdentifier:@"com.apple.MediaPlayerUI"]] forState:UIControlStateNormal];
		backButton.frame = CGRectMake(0, 0, 25, calculateHeight(.039612676));
		backButton.center = CGPointMake(90+width, calculateHeight(.774647887));

		[nextButton addTarget:self action:@selector(touchedNextButton:) forControlEvents:UIControlEventTouchUpInside];
		[nextButton setImage:[UIImage imageNamed:@"SystemMediaControl-Forward-StarkNowPlaying" inBundle:[NSBundle bundleWithIdentifier:@"com.apple.MediaPlayerUI"]] forState:UIControlStateNormal];
		nextButton.frame = CGRectMake(0, 0, 25, calculateHeight(.039612676));
		nextButton.center = CGPointMake(230+width, calculateHeight(.774647887));

		currentAlbumArt.frame = CGRectMake(0, 0, 200, calculateHeight(.352112676));
		currentAlbumArt.center = CGPointMake(160+width, calculateHeight(.491373239));

		newImage.frame = CGRectMake(0, 0, 225, calculateHeight(.396126761));
		overImage.frame = CGRectMake(0, 0, 225, calculateHeight(.616197183));

		[newImage cutHoleInImageView:newImage withSize:CGRectMake(12.5, 12.5, 200, calculateHeight(.352112676))];
		[overImage cutHoleInImageView:overImage withSize:CGRectMake(0, 52.5, 237.5, calculateHeight(.396126761))];

		CALayer* roundedLayer = [overImage layer];
		[roundedLayer setMasksToBounds:YES];
		[roundedLayer setCornerRadius:20.0];

		newImage.center = CGPointMake(160+width, calculateHeight(.491197183));
		newImage.alpha = 0.5;

		overImage.center = CGPointMake(160+width, calculateHeight(.508802817));

		authorLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLightItalic" size:10];
		authorLabel.adjustsFontSizeToFitWidth = YES;
		authorLabel.numberOfLines = 1;
		[authorLabel setCenter:newScroll.center];
		authorLabel.textAlignment = NSTextAlignmentCenter;
		authorLabel.frame = CGRectMake(0, 0, 220, height);
		authorLabel.center = CGPointMake(newScroll.center.x+width, calculateHeight(.218309859));

		titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
		titleLabel.adjustsFontSizeToFitWidth = YES;
		titleLabel.numberOfLines = 1;
		[titleLabel setCenter:newScroll.center];
		titleLabel.textAlignment = NSTextAlignmentCenter;
		titleLabel.frame = CGRectMake(0, 0, 220, height);
		titleLabel.center = CGPointMake(newScroll.center.x+width, calculateHeight(.244288225));

		albumLabel.font = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:10];
		albumLabel.adjustsFontSizeToFitWidth = YES;
		albumLabel.numberOfLines = 1;
		[albumLabel setCenter:newScroll.center];
		albumLabel.textAlignment = NSTextAlignmentCenter;
		albumLabel.frame = CGRectMake(0, 0, 220, height);
		albumLabel.center = CGPointMake(newScroll.center.x+width, calculateHeight(.275528169));

		[art checkColorOfTitle:titleLabel andAuthor:authorLabel andAlbum:albumLabel];

		volumeViewSlider.frame = CGRectMake(0, 0, 180, calculateHeight(.088028169));
		volumeViewSlider.center = CGPointMake(160+width, calculateHeight(.748239437));
		volumeViewSlider.showsRouteButton = NO;
		[volumeViewSlider setVolumeThumbImage:[UIImage imageNamed:@"ControlCenterSliderThumb" inBundle:[NSBundle bundleWithIdentifier:@"com.apple.SpringBoardUIFramework"]] forState:UIControlStateNormal];
		[volumeViewSlider sizeToFit];
		volumeViewSlider = [art updateSliderTint:volumeViewSlider];

		songScrubTimer = [NSTimer timerWithTimeInterval:1 target:art selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
		if ([songScrubTimer isValid]) NSLog(@"Helius--Timer IS VALID");
		if (![songScrubTimer isValid]) [songScrubTimer fire];

		[newScroll addSubview:newImage];
		[newScroll addSubview:overImage];
		[newScroll addSubview:clockLabel];
		[newScroll addSubview:titleLabel];
		[newScroll addSubview:authorLabel];
		[newScroll addSubview:albumLabel];
		[newScroll addSubview:playButton];
		[newScroll addSubview:backButton];
		[newScroll addSubview:nextButton];
		[newScroll addSubview:currentAlbumArt];
		[newScroll addSubview:volumeViewSlider];

	}
	else {
		if (enabled && !isPirated) {
		[newImage removeFromSuperview];
		[overImage removeFromSuperview];
		[clockLabel removeFromSuperview];
		[titleLabel removeFromSuperview];
		[authorLabel removeFromSuperview];
		[albumLabel removeFromSuperview];
		[playButton removeFromSuperview];
		[backButton removeFromSuperview];
		[nextButton removeFromSuperview];
		[currentAlbumArt removeFromSuperview];
		[volumeViewSlider removeFromSuperview];
		[_blurryArtworkView removeFromSuperview];
		}
	}
	%orig;
}

- (void)startAnimatingWithDelay:(BOOL)arg1 {
	if (enabled && !isPirated) arg1 = FALSE;
	%orig(arg1);
}

-(void)glintyAnimationDidStop {
	if (enabled && !isPirated) {
	if (debug) NSLog(@"Helius--glintyAnimationDidTop");
	[clockLabel removeFromSuperview];
	[newImage removeFromSuperview];
	[overImage removeFromSuperview];
	[titleLabel removeFromSuperview];
	[authorLabel removeFromSuperview];
	[albumLabel removeFromSuperview];
	[playButton removeFromSuperview];
	[backButton removeFromSuperview];
	[nextButton removeFromSuperview];
	[currentAlbumArt removeFromSuperview];
	[volumeViewSlider removeFromSuperview];
	}
	%orig;
}

- (void)setMediaControlsHidden:(_Bool)arg1 forRequester:(id)arg2 {
	if (enabled && !isPirated) arg1 = TRUE;
	%orig(arg1, arg2);
}

%new
-(void)touchedPlayButton:(id)arg1 {
	if (debug) NSLog(@"Helius--play touched");
	UpdateArt* art = [[UpdateArt alloc] init];
	playButton = [art updatePlayButton:playButton];
	if (isPlayingMusic && MPMusicPlayerController.iPodMusicPlayer.playbackState != MPMusicPlaybackStateStopped && MPMusicPlayerController.iPodMusicPlayer.playbackState != MPMusicPlaybackStatePaused)  {
		dispatch_async(dispatch_get_main_queue(), ^{
			//[MPMusicPlayerController.iPodMusicPlayer pause];
			[[%c(SBMediaController) sharedInstance] pause];
		});
	}
	else {
		dispatch_async(dispatch_get_main_queue(), ^{
			//[MPMusicPlayerController.iPodMusicPlayer play];
			[[%c(SBMediaController) sharedInstance] play];
		});
	}

}

%new
-(void)touchedBackButton:(id)arg1 {
	if (debug) NSLog(@"Helius--back touched");
	dispatch_async(dispatch_get_main_queue(), ^{
		[MPMusicPlayerController.iPodMusicPlayer skipToPreviousItem];
	});
}

%new
-(void)touchedNextButton:(id)arg1 {
	if (debug) NSLog(@"Helius--next touched");
	dispatch_async(dispatch_get_main_queue(), ^{
		[MPMusicPlayerController.iPodMusicPlayer skipToNextItem];
	});
}

%end

%hook SBLockScreenViewController

- (float)_effectiveOpacityForVisibleDateView {
	if (enabled && !isPirated) {
	if (debug) NSLog(@"Helius--isPlayingMusic FALSE-- _effectiveOpacityForVisibleDateView");

	if (isPlayingMusic) {
		return 0.0;
	}
	}
	return %orig;

}

%end

%hook SBLockScreenViewController

-(void)lockScreenView:(id)arg1 didScrollToPage:(int)arg2 {
	if (enabled && !isPirated) {
	if(arg2 != 1) {
		if (debug) NSLog(@"Helius-- lockScreenView--arg2 != 1");
		[clockLabel removeFromSuperview];
		[newImage removeFromSuperview];
		[overImage removeFromSuperview];
		[titleLabel removeFromSuperview];
		[authorLabel removeFromSuperview];
		[albumLabel removeFromSuperview];
		[playButton removeFromSuperview];
		[backButton removeFromSuperview];
		[nextButton removeFromSuperview];
		[currentAlbumArt removeFromSuperview];
		[volumeViewSlider removeFromSuperview];
	}
	else if (arg2 == 1 && isPlayingMusic) {
		if (debug) NSLog(@"Helius-- lockScreenView--arg2 == 1 && isPlayingMusic");
		[newScroll addSubview:newImage];
		[newScroll addSubview:overImage];
		[newScroll addSubview:clockLabel];
		[newScroll addSubview:titleLabel];
		[newScroll addSubview:authorLabel];
		[newScroll addSubview:albumLabel];
		[newScroll addSubview:playButton];
		[newScroll addSubview:backButton];
		[newScroll addSubview:nextButton];
		[newScroll addSubview:currentAlbumArt];
		[newScroll addSubview:volumeViewSlider];
	}
	}
	%orig;
}

%end

%hook _NowPlayingArtView

-(CGSize)_artworkSize {
	if (enabled && !isPirated) {
	if (debug) NSLog(@"Helius-- _artworkSize");
	return CGSizeMake(0, 0);
	}
	return %orig;
}

%end

%end

//SPECTRAL CODE
#define PREFERENCES_PATH @"/User/Library/Preferences/com.phillipt.helius.plist"
#define PREFERENCES_CHANGED_NOTIFICATION "com.phillipt.helius/preferencechanged"
#define PREFERENCES_ENABLED_KEY @"enabled"

%group NowPlayingArtView

%hook NowPlayingArtPluginController
- (void)viewWillAppear:(BOOL)animated {
	%orig;
	if (enabled && blurBack && !isPirated) [[%c(SBUIController) sharedInstance] updateLockscreenArtwork];
}

- (void)viewWillDisappear:(BOOL)animated {
	%orig;
	if (enabled && blurBack && !isPirated) [[%c(SBUIController) sharedInstance] updateLockscreenArtwork];
}
%end

%hook SBUIController
- (id)init {
	SBUIController *controller = %orig;

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(currentSongChanged:)
												 name:@"SBMediaNowPlayingChangedNotification"
											   object:nil];

	if (enabled && blurBack && !isPirated) _blurryArtworkView = [[SBBlurryArtworkView alloc] initWithFrame:CGRectZero];

	if (isPlayingMusic) return controller;

	return controller;
}

%new
- (void)updateLockscreenArtwork {
	[[NSOperationQueue mainQueue] addOperationWithBlock:^(){
		SBMediaController *mediaController = [%c(SBMediaController) sharedInstance];

		//TODO: Try to limit the number of times this needs to be run because it's expensive
		NSData *artworkData = [[mediaController _nowPlayingInfo] valueForKey:@"artworkData"];
		if (artworkData == _artworkData) {
			return;
		}
		if (isPlayingMusic) _artworkData = artworkData;

		UIImage *artwork = mediaController.artwork;
		if (isPlayingMusic) self.lockscreenArtworkImage = artwork;
	}];
}

%new
- (void)currentSongChanged:(NSNotification *)notification {
	if (isPlayingMusic) [self updateLockscreenArtwork];
}

%new
- (void)blurryArtworkPreferencesChanged {
	NSDictionary *prefs = [[NSDictionary alloc] initWithContentsOfFile:PREFERENCES_PATH];
	BOOL enabled = [[prefs valueForKey:PREFERENCES_ENABLED_KEY] boolValue];

	_blurryArtworkView.hidden = !enabled;
}

%new
- (void)setLockscreenArtworkImage:(UIImage *)artworkImage {
	if (isPlayingMusic) _blurryArtworkView.artworkImage = artworkImage;
}

%new
- (SBBlurryArtworkView *)blurryArtworkView {
	if (isPlayingMusic) return _blurryArtworkView;
	return _blurryArtworkView;
}

// Fix for the original lockscreen wallpaper not showing when locked and paused
- (void)cleanUpOnFrontLocked {
	%orig;
	if (enabled && blurBack && !isPirated) {
	SBMediaController *mediaController = [%c(SBMediaController) sharedInstance];
	if (!mediaController.isPlaying) {
		self.lockscreenArtworkImage = nil;
	}
	if (!isPlayingMusic) self.lockscreenArtworkImage = nil;
	}
}

%end

%hook _NowPlayingArtView

- (void)layoutSubviews {
	%orig;
	if (enabled && blurBack && !isPirated) {
	if (isPlayingMusic) _blurryArtworkView.frame = [UIScreen mainScreen].bounds;

// Hack to find the SBLockScreenScrollView and use it as a reference point
// ...don't ever use this in shipping code :P

	SBLockScreenScrollView *scrollView = nil;
	UIView *superview = self.superview;
	Class SBLockScreenScrollViewClass = %c(SBLockScreenScrollView);
	while (scrollView == nil) {
		for (UIView *subview in superview.subviews) {
			if ([subview isKindOfClass:SBLockScreenScrollViewClass])
				scrollView = (SBLockScreenScrollView *)subview;
		}

		superview = superview.superview;
		if (superview == nil)
			break;
	}

	if (_blurryArtworkView.superview != nil)
		[_blurryArtworkView removeFromSuperview];
	if (scrollView != nil)
		if (isPlayingMusic) [scrollView.superview insertSubview:_blurryArtworkView belowSubview:scrollView];
	if (!isPlayingMusic) [_blurryArtworkView removeFromSuperview];
	}
}

%end

%end

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	_preferences = [[NSDictionary alloc] initWithContentsOfFile:PREFERENCES_PATH];

	[[%c(SBUIController) sharedInstance] blurryArtworkPreferencesChanged];
}

void loadPreferences () {
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.phillipt.helius.plist"]];

	if ([prefs objectForKey:@"enabled"] == nil) enabled = YES;
	else enabled = [[prefs objectForKey:@"enabled"] boolValue];

	if ([prefs objectForKey:@"blurBack"] == nil) blurBack = YES;
	else blurBack = [[prefs objectForKey:@"blurBack"] boolValue];

	if ([prefs objectForKey:@"upwardCompatible"] == nil) upwardCompatible = YES;
	else upwardCompatible = [[prefs objectForKey:@"upwardCompatible"] boolValue];

	if ([prefs objectForKey:@"crossfade"] == nil) crossfade = YES;
	else crossfade = [[prefs objectForKey:@"crossfade"] boolValue];

	if ([prefs objectForKey:@"crossfadeDuration"] == nil) crossfadeDuration = 1;
    else crossfadeDuration = [[prefs objectForKey:@"crossfadeDuration"] intValue];

	NSLog(@"Helius--%@", [prefs description]);
	NSLog(@"Helius--%d, %d, %d, %d", enabled, blurBack, upwardCompatible, crossfade);
}

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
									NULL,
									(CFNotificationCallback)loadPreferences,
									CFSTR("com.phillipt.helius/preferencechanged"),
									NULL,
									CFNotificationSuspensionBehaviorDeliverImmediately);
	loadPreferences();
	if (debug) NSLog(@"Helius--%@", objc_getClass("_NowPlayingArtView"));
	if ([[NSBundle bundleWithPath:@"/System/Library/SpringBoardPlugins/NowPlayingArtLockScreen.lockbundle"] load]) {
		if (debug) NSLog(@"Helius--bundle loaded succesfully!");
	}
	else {
		if (debug) NSLog(@"Helius--bundle did not load succesfully.");
	}
	if (debug) NSLog(@"Helius--%@", [NSBundle bundleWithPath:@"/System/Library/SpringBoardPlugins/NowPlayingArtLockScreen.lockbundle"]);

	register_for_nsnotifications_on_object(MPMusicPlayerControllerPlaybackStateDidChangeNotification, MPMusicPlayerController.iPodMusicPlayer, [MAMusicArtController sharedInstance], @selector(playbackStateDidChange:));
	register_for_nsnotifications_on_object(MPMusicPlayerControllerNowPlayingItemDidChangeNotification, MPMusicPlayerController.iPodMusicPlayer, [MAMusicArtController sharedInstance], @selector(nowPlayingItemDidChange:));

	[MPMusicPlayerController.iPodMusicPlayer beginGeneratingPlaybackNotifications];

	dlopen("/System/Library/SpringBoardPlugins/NowPlayingArtLockScreen.lockbundle/NowPlayingArtLockScreen", 2);

	_preferences = [[NSDictionary alloc] initWithContentsOfFile:PREFERENCES_PATH];
	if (_preferences == nil) {
		_preferences = @{ PREFERENCES_ENABLED_KEY : @(YES) };
		[_preferences writeToFile:PREFERENCES_PATH atomically:YES];
	}

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PreferencesChangedCallback, CFSTR(PREFERENCES_CHANGED_NOTIFICATION), NULL, CFNotificationSuspensionBehaviorCoalesce);

	if ([prefs objectForKey:@"enabled"] == nil) enabled = YES;
	else enabled = [[prefs objectForKey:@"enabled"] boolValue];

	if ([prefs objectForKey:@"blurBack"] == nil) blurBack = YES;
	else blurBack = [[prefs objectForKey:@"blurBack"] boolValue];

	if ([prefs objectForKey:@"upwardCompatible"] == nil) upwardCompatible = NO;
	else upwardCompatible = [[prefs objectForKey:@"upwardCompatible"] boolValue];

	if ([prefs objectForKey:@"crossfade"] == nil) crossfade = YES;
	else crossfade = [[prefs objectForKey:@"crossfade"] boolValue];

	if ([prefs objectForKey:@"debug"] == nil) debug = NO;
	else debug = [[prefs objectForKey:@"debug"] boolValue];

	if ([prefs objectForKey:@"crossfadeDuration"] == nil) crossfadeDuration = 1;
    else crossfadeDuration = [[prefs objectForKey:@"crossfadeDuration"] intValue];

	%init(NowPlayingArtView);
	%init(Main);

	if (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/org.thebigboss.helius.list"] && ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.phillipt.helius.list"]) {
        isPirated = TRUE;
    }
}
