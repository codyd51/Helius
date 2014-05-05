#import "_NowPlayingArtView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PrivateHeaders.h"
#import "BlurImage.m"
#import "UIImageAverageColorAddition.m"
#import "UIImageCropRect.m"
#import <QuartzCore/QuartzCore.h>

#define _NSC_ [NSNotificationCenter defaultCenter]
#define register_for_nsnotifications_on_object(_name, _object, observer, callback) [_NSC_ addObserver:observer selector:callback name:_name object:_object]

BOOL isPlayingMusic;
UIImage* croppedImage = [[UIImage alloc] init];
UILabel* clockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 568)];
UILabel* authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 568)];
UILabel* albumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 568)];
UIButton *playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
UIImage *backImage = [[UIImage alloc] init];
UIImage *maskImage = [[UIImage alloc] init];
UIImage* lightColor = [[UIImage alloc] init];
UIImageView* overImage = [[UIImageView alloc] init];
UIColor* color = [[UIColor alloc] init];
UIImage* darkArt;
UIImageView* newImage;
static UIView* wind;

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
	UpdateArt* art = [[UpdateArt alloc] init];
	darkArt = [art updateAlbumArt:darkArt];
    color = [art updateAlbumColor:color];
    backImage = [art updateBackImage:backImage];
    lightColor = [art updateLightColor:lightColor];
    newImage = [art updateNewImage];
    overImage = [art updateOverImage];
    authorLabel.text = [art updateAuthorLabel];
    titleLabel.text = [art updateTitleLabel];
    albumLabel.text = [art updateAlbumLabel];
    NSLog(@"MusicArt--nowPlayingItemDidChange");
}
- (void)playbackStateDidChange:(id)notification {
	UpdateArt* art = [[UpdateArt alloc] init];
	darkArt = [art updateAlbumArt:darkArt];
    color = [art updateAlbumColor:color];
    backImage = [art updateBackImage:backImage];
    lightColor = [art updateLightColor:lightColor];
    newImage = [art updateNewImage];
    overImage = [art updateOverImage];
    authorLabel.text = [art updateAuthorLabel];
    titleLabel.text = [art updateTitleLabel];
    albumLabel.text = [art updateAlbumLabel];
    NSLog(@"MusicArt--playbackStateDidChange");
}
@end

%hook SBLockScreenNowPlayingPluginController

- (BOOL)isNowPlayingPluginActive {
	BOOL check = %orig;
	if (check) {
		isPlayingMusic = YES;
	}
	else if (!check) {
		isPlayingMusic = NO;
		[clockLabel removeFromSuperview];
		[newImage removeFromSuperview];
		[overImage removeFromSuperview];
		[titleLabel removeFromSuperview];
		[authorLabel removeFromSuperview];
		[albumLabel removeFromSuperview];
		[playButton removeFromSuperview];
		[backButton removeFromSuperview];
		[nextButton removeFromSuperview];
	}
	return check;
}

%end

%hook SBLockScreenView

-(void)setCustomSlideToUnlockText:(id)arg1 {
	if (isPlayingMusic) {
		[wind addSubview:clockLabel];
		[wind addSubview:newImage];
		[wind addSubview:overImage];
		[wind addSubview:titleLabel];
		[wind addSubview:authorLabel];
		[wind addSubview:albumLabel];
		[wind addSubview:playButton];
		[wind addSubview:backButton];
		[wind addSubview:nextButton];
	}
	else if (!isPlayingMusic) {
		[clockLabel removeFromSuperview];
		[newImage removeFromSuperview];
		[overImage removeFromSuperview];
		[titleLabel removeFromSuperview];
		[authorLabel removeFromSuperview];
		[albumLabel removeFromSuperview];
		[playButton removeFromSuperview];
		[backButton removeFromSuperview];
		[nextButton removeFromSuperview];
	}
    %orig(arg1);
}

- (void)glintyAnimationDidStart {
	if (isPlayingMusic) {

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

		wind = MSHookIvar<UIView *>(self, "_foregroundView");
		NSDateFormatter* DateFormatter=[[NSDateFormatter alloc] init];
		[DateFormatter setDateFormat:@"hh:mm"];
		NSLog(@"MusicTest--%@",[DateFormatter stringFromDate:[NSDate date]]);

		clockLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:60];
		clockLabel.adjustsFontSizeToFitWidth = YES;
		[clockLabel setTextColor:[UIColor whiteColor]];
		clockLabel.numberOfLines = 1;
		[clockLabel setCenter:wind.center];
		clockLabel.textAlignment = NSTextAlignmentCenter;
		clockLabel.text = [NSString stringWithFormat:@"%@", [DateFormatter stringFromDate:[NSDate date]]];
		clockLabel.center = CGPointMake(wind.center.x, wind.center.y-220);

		authorLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLightItalic" size:10];
		authorLabel.adjustsFontSizeToFitWidth = YES;
		[authorLabel setTextColor:[UIColor whiteColor]];
		authorLabel.numberOfLines = 1;
		[authorLabel setCenter:wind.center];
		authorLabel.textAlignment = NSTextAlignmentCenter;
		authorLabel.text = [art updateAuthorLabel];
		authorLabel.center = CGPointMake(wind.center.x, wind.center.y-160);

		titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
		titleLabel.adjustsFontSizeToFitWidth = YES;
		[titleLabel setTextColor:[UIColor whiteColor]];
		titleLabel.numberOfLines = 1;
		[titleLabel setCenter:wind.center];
		titleLabel.textAlignment = NSTextAlignmentCenter;
		titleLabel.text = [art updateTitleLabel];
		titleLabel.center = CGPointMake(wind.center.x, wind.center.y-145);

		albumLabel.font = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:10];
		albumLabel.adjustsFontSizeToFitWidth = YES;
		[albumLabel setTextColor:[UIColor whiteColor]];
		albumLabel.numberOfLines = 1;
		[albumLabel setCenter:wind.center];
		albumLabel.textAlignment = NSTextAlignmentCenter;
		albumLabel.text = [art updateAlbumLabel];
		albumLabel.center = CGPointMake(wind.center.x, wind.center.y-127.5);
/*
		[playButton addTarget:playButton 
           	action:@selector(touchedPlayButton)
 			forControlEvents:UIControlEventTouchUpInside];
		[playButton setTitle:@"Play" forState:UIControlStateNormal];
		playButton.frame = CGRectMake(0, 0, 320, 568);

		[backButton addTarget:backButton
           	action:@selector(touchedBackButton)
 			forControlEvents:UIControlEventTouchUpInside];
		[backButton setTitle:@"Back" forState:UIControlStateNormal];
		backButton.frame = CGRectMake(0, 0, 320, 568);

		[nextButton addTarget:self 
           	action:@selector(touchedNextButton)
 			forControlEvents:UIControlEventTouchUpInside];
		[nextButton setTitle:@"Next" forState:UIControlStateNormal];
		nextButton.frame = CGRectMake(0, 0, 320, 568);
*/
		darkArt = [art updateAlbumArt:darkArt];
		color = [art updateAlbumColor:color];

		backImage = [art updateBackImage:backImage];

		lightColor = [art updateLightColor:lightColor];

		newImage = [[UIImageView alloc] init];
		newImage = [art updateNewImage];

		overImage = [[UIImageView alloc] init];
		overImage = [art updateOverImage];

		newImage.frame = CGRectMake(0, 0, 225, 225);
		overImage.frame = CGRectMake(0, 0, 225, 350);

		[newImage cutHoleInImageView:newImage withSize:CGRectMake(12.5, 12.5, 200, 200)];

		[overImage cutHoleInImageView:overImage withSize:CGRectMake(0, 52.5, 237.5, 225)];

		CALayer* roundedLayer = [overImage layer];
		[roundedLayer setMasksToBounds:YES];
		[roundedLayer setCornerRadius:20.0];

		newImage.center = CGPointMake(160, 279);
		newImage.alpha = 0.5;

		overImage.center = CGPointMake(160, 289);

		[wind addSubview:newImage];
		[wind addSubview:overImage];
		[wind addSubview:clockLabel];
		[wind addSubview:titleLabel];
		[wind addSubview:authorLabel];
		[wind addSubview:albumLabel];
		[wind addSubview:playButton];
		[wind addSubview:backButton];
		[wind addSubview:nextButton];

	}
    else if (!isPlayingMusic) {
    	[newImage removeFromSuperview];
    	[overImage removeFromSuperview];
    	[clockLabel removeFromSuperview];
    	[titleLabel removeFromSuperview];
    	[authorLabel removeFromSuperview];
    	[albumLabel removeFromSuperview];
    	[playButton removeFromSuperview];
    	[backButton removeFromSuperview];
    	[nextButton removeFromSuperview];
    }
    %orig;
}

-(void)glintyAnimationDidStop {
	[clockLabel removeFromSuperview];
	[newImage removeFromSuperview];
	[overImage removeFromSuperview];
	[titleLabel removeFromSuperview];
	[authorLabel removeFromSuperview];
	[albumLabel removeFromSuperview];
	[playButton removeFromSuperview];
	[backButton removeFromSuperview];
	[nextButton removeFromSuperview];
	%orig;
}

- (void)setMediaControlsHidden:(_Bool)arg1 forRequester:(id)arg2 {
	arg1 = TRUE;
	%orig(arg1, arg2);
}

%end

%hook SBLockScreenViewController

- (float)_effectiveOpacityForVisibleDateView {

	if (isPlayingMusic) return 0.0;

	return %orig;

}

%end

%hook SBLockScreenViewController

-(void)lockScreenView:(id)arg1 didScrollToPage:(int)arg2 {
    if(arg2 != 1) {
    	[clockLabel removeFromSuperview];
    	[newImage removeFromSuperview];
    	[overImage removeFromSuperview];
    	[titleLabel removeFromSuperview];
    	[authorLabel removeFromSuperview];
    	[albumLabel removeFromSuperview];
    	[playButton removeFromSuperview];
    	[backButton removeFromSuperview];
    	[nextButton removeFromSuperview];
    }
    else if (arg2 == 1 && isPlayingMusic) {
    	[wind addSubview:clockLabel];
    	[wind addSubview:newImage];
    	[wind addSubview:overImage];
    	[wind addSubview:titleLabel];
    	[wind addSubview:authorLabel];
    	[wind addSubview:albumLabel];
    	[wind addSubview:playButton];
		[wind addSubview:backButton];
		[wind addSubview:nextButton];
    }
    %orig;
}

%end

%hook _NowPlayingArtView

-(CGSize)_artworkSize {
	return CGSizeMake(200, 200);
}

%end

%ctor {
	NSLog(@"MusicTest--%@", objc_getClass("_NowPlayingArtView"));
	if ([[NSBundle bundleWithPath:@"/System/Library/SpringBoardPlugins/NowPlayingArtLockScreen.lockbundle"] load]) {
		NSLog(@"MusicTest--bundle loaded succesfully!");
	} 
	else { 
		NSLog(@"MusicTest--bundle did not load succesfully.");
	}
	NSLog(@"MusicTest--%@", [NSBundle bundleWithPath:@"/System/Library/SpringBoardPlugins/NowPlayingArtLockScreen.lockbundle"]);

	register_for_nsnotifications_on_object(MPMusicPlayerControllerPlaybackStateDidChangeNotification, MPMusicPlayerController.iPodMusicPlayer, [MAMusicArtController sharedInstance], @selector(playbackStateDidChange:));
	register_for_nsnotifications_on_object(MPMusicPlayerControllerNowPlayingItemDidChangeNotification, MPMusicPlayerController.iPodMusicPlayer, [MAMusicArtController sharedInstance], @selector(nowPlayingItemDidChange:));

	[MPMusicPlayerController.iPodMusicPlayer beginGeneratingPlaybackNotifications];
}
