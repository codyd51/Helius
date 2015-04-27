#import "BlurImage.h"
#import "PrivateHeaders.h"
#import "UIImageAverageColorAddition.m"
#import "substrate.h"
@interface SBMediaController : NSObject {
	int _manualVolumeChangeCount;
	NSDictionary* _nowPlayingInfo;
	float _pendingVolumeChange;
	NSTimer* _volumeCommitTimer;
	BOOL _debounceVolumeRepeat;
}
+(id)sharedInstance;
// inherited: -(id)init;
// inherited: -(void)dealloc;
-(void)setNowPlayingInfo:(id)info;
-(BOOL)hasTrack;
-(BOOL)isFirstTrack;
-(BOOL)isLastTrack;
-(BOOL)isPlaying;
-(BOOL)isMovie;
-(BOOL)isTVOut;
-(id)nowPlayingArtist;
-(id)nowPlayingTitle;
-(id)nowPlayingAlbum;
-(BOOL)changeTrack:(int)track;
-(BOOL)beginSeek:(int)seek;
-(BOOL)endSeek:(int)seek;
-(BOOL)togglePlayPause;
-(float)volume;
-(void)setVolume:(float)volume;
-(void)_changeVolumeBy:(float)by;
-(float)_calcButtonRepeatDelay;
-(void)increaseVolume;
-(void)decreaseVolume;
-(void)cancelVolumeEvent;
-(void)handleVolumeEvent:(GSEventRef)event;
-(void)_registerForAVSystemControllerNotifications;
-(void)_unregisterForAVSystemControllerNotifications;
-(void)_serverConnectionDied:(id)died;
-(void)_systemVolumeChanged:(id)changed;
-(void)_cancelPendingVolumeChange;
-(void)_commitVolumeChange:(id)change;
-(void)_delayedExtendSleepTimer;
@end


@interface UIColor (Extensions)
- (UIColor*)changeBrightnessByAmount:(CGFloat)amount;
@end

@implementation UIColor (Extensions)
- (UIColor*)changeBrightnessByAmount:(CGFloat)amount {
	CGFloat hue, saturation, brightness, alpha;
	if ([self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
		brightness += (amount - 1.0);
		brightness = MAX(MIN(brightness, 1.0), 0.0);
		return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
	}

	CGFloat white;
	if ([self getWhite:&white alpha:&alpha]) {
		white += (amount - 1.0);
		white = MAX(MIN(white, 1.0), 0.0);
		return [UIColor colorWithWhite:white alpha:alpha];
	}

	return self;
}
@end
@interface UpdateArt : NSObject
void runOnMainQueueWithoutDeadlocking(void (^block)(void));
- (UIColor *)darkerColorForColor:(UIColor *)c;
-(UIImage*)updateAlbumArt:(UIImage*)image andSize:(CGSize)size;
-(UIColor*)updateAlbumColor:(UIColor*)color;
-(UIImage*)updateLightColor:(UIImage*)image;
-(UIImageView*)updateNewImage;
-(UIImageView*)updateOverImage;
-(NSString*)updateAuthorLabel;
-(NSString*)updateTitleLabel;
-(NSString*)updateAlbumLabel;
-(void)checkColorOfTitle:(UILabel*)titleLabel andAuthor:(UILabel*)authorLabel andAlbum:(UILabel*)albumLabel;
-(UIButton*)updatePlayButton:(UIButton*)playButton;
-(MPVolumeView*)updateSliderTint:(MPVolumeView*)view;
-(void)updateProgressBar;
@end

@implementation UpdateArt
void runOnMainQueueWithoutDeadlocking(void (^block)(void))
{
	if ([NSThread isMainThread])
	{
		block();
	}
	else
	{
		dispatch_sync(dispatch_get_main_queue(), block);
	}
}
- (UIColor *)darkerColorForColor:(UIColor *)c {
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.1, 0.0)
                               green:MAX(g - 0.1, 0.0)
                                blue:MAX(b - 0.1, 0.0)
                               alpha:a];
    return nil;
}
-(UIImage*)updateAlbumArt:(UIImage*)image andSize:(CGSize)size {
	if (debug) NSLog(@"MusicTest--updateAlbumArt");
	//NSAssert([NSThread isMainThread], @"Not running on the main thread!");
	//image = [MPMusicPlayerController.iPodMusicPlayer.nowPlayingItem.artwork imageWithSize:CGSizeMake(225, 225)];
	//image = [MPMusicPlayerController.iPodMusicPlayer.nowPlayingItem.artwork imageWithSize:size];
	image = [[[[%c(SBMediaController) sharedInstance] nowPlayingArtist] artwork] imageWithSize:size];
	if (debug) NSLog(@"MusicTest--finished updateAlbumArt");
	return image;
}
-(UIColor*)updateAlbumColor:(UIColor*)color {
	if (debug) NSLog(@"MusicTest--updateAlbumColor");
	color = [darkArt mergedColor];
	return color;
}
-(UIImage*)updateBackImage:(UIImage*)image {
	if (debug) NSLog(@"MusicTest--updateBackImage");
	image = [BlurImage imageWithColor:color andSize:CGRectMake(0, 0, 200, 200)];
	return image;
}
-(UIImage*)updateLightColor:(UIImage*)image {
	if (debug) NSLog(@"MusicTest--updateLightColor");
	image = [BlurImage imageWithColor:color andSize:CGRectMake(0, 0, 200, 350)];
	return image;
}
-(UIImageView*)updateNewImage {
	if (debug) NSLog(@"MusicTest--updateNewImage");
	newImage.image = backImage;
	return newImage;
}
-(UIImageView*)updateOverImage {
	if (debug) NSLog(@"MusicTest--updateOverImage");
	overImage.image = lightColor;
	return overImage;
}
-(NSString*)updateAuthorLabel {
	if (debug) NSLog(@"MusicTest--updateAuthorLabel");
	NSString* newText;
	if ([[%c(SBMediaController) sharedInstance] nowPlayingArtist] == nil) {
		newText = [NSString stringWithFormat:@"No artist"];
	}
	else {
		//newText = [NSString stringWithFormat:@"%@", MPMusicPlayerController.iPodMusicPlayer.nowPlayingItem.artist];
		newText = [NSString stringWithFormat:@"@", [[%c(SBMediaController) sharedInstance] nowPlayingArtist]];
	}
	return newText;
}
-(NSString*)updateTitleLabel {
	if (debug) NSLog(@"MusicTest--updateTitleLabel");
	NSString* newText;
	//if (MPMusicPlayerController.iPodMusicPlayer.nowPlayingItem.title == nil) {
	if ([[%c(SBMediaController) sharedInstance] nowPlayingTitle] == nil) {
	  newText = [NSString stringWithFormat:@"No title"];
	}
  	else {
		//newText = [NSString stringWithFormat:@"%@", MPMusicPlayerController.iPodMusicPlayer.nowPlayingItem.title];
		newText = [NSString stringWithFormat:@"%@", [[%c(SBMediaController) sharedInstance] nowPlayingTitle]];
	} 
	return newText;
}
-(NSString*)updateAlbumLabel {
	if (debug) NSLog(@"MusicTest--updateAlbumLabel");
	NSString* newText;
	//if (MPMusicPlayerController.iPodMusicPlayer.nowPlayingItem.albumTitle == nil) {
	if ([[%c(SBMediaController) sharedInstance] nowPlayingAlbum] == nil) {
		newText = [NSString stringWithFormat:@"No album"];
	}
	else {
		//newText = [NSString stringWithFormat:@"%@", MPMusicPlayerController.iPodMusicPlayer.nowPlayingItem.albumTitle];
		newText = [NSString stringWithFormat:@"%@", [[%c(SBMediaController) sharedInstance] nowPlayingAlbum]];
	}
	return newText;
}
-(void)checkColorOfTitle:(UILabel*)titleLabel andAuthor:(UILabel*)authorLabel andAlbum:(UILabel*)albumLabel {
	//if (color < [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.0]) {
	if (debug) NSLog(@"MusicTest--checkColorOfTitle");
	if (1==1) {
		[titleLabel setTextColor:[UIColor whiteColor]];
		[authorLabel setTextColor:[UIColor whiteColor]];
		[albumLabel setTextColor:[UIColor whiteColor]];
	}
	else {
		[titleLabel setTextColor:[UIColor blackColor]];
		[authorLabel setTextColor:[UIColor blackColor]];
		[albumLabel setTextColor:[UIColor blackColor]];
	}
}
-(UIButton*)updatePlayButton:(UIButton*)playButton {
	if (debug) NSLog(@"MusicTest--updatePlayButton");
	if (MPMusicPlayerController.iPodMusicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
		[playButton setImage:[UIImage imageNamed:@"SystemMediaControl-Pause-StarkNowPlaying" inBundle:[NSBundle bundleWithIdentifier:@"com.apple.MediaPlayerUI"]] forState:UIControlStateNormal];
		return playButton;
	}
	else {
		[playButton setImage:[UIImage imageNamed:@"SystemMediaControl-Play-StarkNowPlaying" inBundle:[NSBundle bundleWithIdentifier:@"com.apple.MediaPlayerUI"]] forState:UIControlStateNormal];
		return playButton;
	}
}
-(MPVolumeView*)updateSliderTint:(MPVolumeView*)view {
	//UIColor *darkerColor = [self darkerColorForColor:[darkArt mergedColor]];
	UIColor* darkerColor  = [[darkArt mergedColor] changeBrightnessByAmount:0.9];
	view.tintColor = darkerColor;
	return view;
}
//- (void)updateProgressBar:(NSTimer *) timer {
-(void)updateProgressBar {
	//if (MPMusicPlayerController.iPodMusicPlayer.currentPlaybackTime != lengthOfSong) {
	//if (MPMusicPlayerController.iPodMusicPlayer.currentPlaybackTime > 100) {
	NSLog(@"MusicTest--progress bar incremented");
	//[progressView setProgress:MPMusicPlayerController.iPodMusicPlayer.currentPlaybackTime/200];
   // }
	//else {
		//[timer invalidate], timer = nil;
		//[self.progressBar setValue:lengthOfSong];
	 //   return ;
   // }
}
@end
/*
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
	NSLog(@"MusicTest--nowPlayingItemDidChange");
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
	[art checkColorOfTitle:titleLabel andAuthor:authorLabel andAlbum:albumLabel];
}
- (void)playbackStateDidChange:(id)notification {
	NSLog(@"MusicTest--playbackStateDidChange");
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
	[art checkColorOfTitle:titleLabel andAuthor:authorLabel andAlbum:albumLabel];
}
@end
*/
@implementation BlurImage
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGRect)size {
	//CGRect rect = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
	NSLog(@"MusicTest--imageWithColor %@ andSize", color);
	CGRect rect = size;
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);

	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return image;
}
/*
-(void)touchedPlayButton {
	NSLog(@"MusicTest--play touched");
	if (MPMusicPlayerController.iPodMusicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
		[MPMusicPlayerController.iPodMusicPlayer pause];
	}
	else {
		[MPMusicPlayerController.iPodMusicPlayer play];
	}
}
-(void)touchedBackButton {
	NSLog(@"MusicTest--back touched");
	[MPMusicPlayerController.iPodMusicPlayer skipToPreviousItem];
}
-(void)touchedNextButton {
	NSLog(@"MusicTest--next touched");
	//[MPMusicPlayerController.iPodMusicPlayer skipToNextItem];
}
+ (UIImage *) setImage:(UIImage *)image withAlpha:(CGFloat)alpha{

	// Create a pixel buffer in an easy to use format
	CGImageRef imageRef = [image CGImage];
	NSUInteger width = CGImageGetWidth(imageRef);
	NSUInteger height = CGImageGetHeight(imageRef);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

	UInt8 * m_PixelBuf = malloc(sizeof(UInt8) * height * width * 4);

	NSUInteger bytesPerPixel = 4;
	NSUInteger bytesPerRow = bytesPerPixel * width;
	NSUInteger bitsPerComponent = 8;
	CGContextRef context = CGBitmapContextCreate(m_PixelBuf, width, height,
												 bitsPerComponent, bytesPerRow, colorSpace,
												 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

	CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
	CGContextRelease(context);

	//alter the alpha
	int length = height * width * 4;
	for (int i=0; i<length; i+=4)
	{
		m_PixelBuf[i+3] =  255*alpha;
	}


	//create a new image
	CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf, width, height,
												 bitsPerComponent, bytesPerRow, colorSpace,
												 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

	CGImageRef newImgRef = CGBitmapContextCreateImage(ctx);  
	CGColorSpaceRelease(colorSpace);
	CGContextRelease(ctx);  
	free(m_PixelBuf);

	UIImage *finalImage = [UIImage imageWithCGImage:newImgRef];
	CGImageRelease(newImgRef);  

	return finalImage;
}*/
@end

@implementation UIImage (CustomAlpha)
- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha {
	NSLog(@"MusicTest--imageByApplyingAlpha");
	UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);

	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);

	CGContextScaleCTM(ctx, 1, -1);
	CGContextTranslateCTM(ctx, 0, -area.size.height);

	CGContextSetBlendMode(ctx, kCGBlendModeMultiply);

	CGContextSetAlpha(ctx, alpha);

	CGContextDrawImage(ctx, area, self.CGImage);

	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

	UIGraphicsEndImageContext();

	return newImage;
}
@end
@implementation UIImageView (CutHole)
-(void)cutHoleInImageView:(UIImageView*)imageView withSize:(CGRect)rect {
	NSLog(@"MusicTest--cutHoleInImageView %@ withSize", imageView);
	CGRect r = imageView.bounds;
	CGRect r2 = rect; // adjust this as desired!
	UIGraphicsBeginImageContextWithOptions(r.size, NO, 0);
	CGContextRef c = UIGraphicsGetCurrentContext();
	CGContextAddRect(c, r2);
	CGContextAddRect(c, r);
	CGContextEOClip(c);
	CGContextSetFillColorWithColor(c, [UIColor blackColor].CGColor);
	CGContextFillRect(c, r);
	UIImage* maskim = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	CALayer* mask = [CALayer layer];
	mask.frame = r;
	mask.contents = (id)maskim.CGImage;
	imageView.layer.mask = mask;
}
@end
