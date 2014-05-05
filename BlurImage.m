#import "BlurImage.h"
#import "PrivateHeaders.h"
#import "UIImageAverageColorAddition.m"

@interface UpdateArt : NSObject
-(UIImage*)updateAlbumArt:(UIImage*)image;
-(UIColor*)updateAlbumColor:(UIColor*)color;
-(UIImage*)updateLightColor:(UIImage*)image;
-(UIImageView*)updateNewImage;
-(UIImageView*)updateOverImage;
-(NSString*)updateAuthorLabel;
-(NSString*)updateTitleLabel;
-(NSString*)updateAlbumLabel;
@end

@implementation UpdateArt
-(UIImage*)updateAlbumArt:(UIImage*)image {
    image = [MPMusicPlayerController.iPodMusicPlayer.nowPlayingItem.artwork imageWithSize:CGSizeMake(225, 225)];
    return image;
}
-(UIColor*)updateAlbumColor:(UIColor*)color {
    color = [darkArt mergedColor];
    return color;
}
-(UIImage*)updateBackImage:(UIImage*)image {
    image = [BlurImage imageWithColor:color andSize:CGRectMake(0, 0, 200, 200)];
    return image;
}
-(UIImage*)updateLightColor:(UIImage*)image {
    image = [BlurImage imageWithColor:color andSize:CGRectMake(0, 0, 200, 350)];
    return image;
}
-(UIImageView*)updateNewImage {
    newImage.image = backImage;
    return newImage;
}
-(UIImageView*)updateOverImage {
    overImage.image = lightColor;
    return overImage;
}
-(NSString*)updateAuthorLabel {
    NSString* newText;
    if (MPMusicPlayerController.iPodMusicPlayer.nowPlayingItem.artist == nil) {
        newText = [NSString stringWithFormat:@"No artist"];
    }
    else {
        newText = [NSString stringWithFormat:@"%@", MPMusicPlayerController.iPodMusicPlayer.nowPlayingItem.artist];
    }
    return newText;
}
-(NSString*)updateTitleLabel {
    NSString* newText;
    if (MPMusicPlayerController.iPodMusicPlayer.nowPlayingItem.title == nil) {
        newText = [NSString stringWithFormat:@"No title"];
    }
    else {
        newText = [NSString stringWithFormat:@"%@", MPMusicPlayerController.iPodMusicPlayer.nowPlayingItem.title];
    } 
    return newText;
}
-(NSString*)updateAlbumLabel {
    NSString* newText;
    if (MPMusicPlayerController.iPodMusicPlayer.nowPlayingItem.albumTitle == nil) {
        newText = [NSString stringWithFormat:@"No album"];
    }
    else {
        newText = [NSString stringWithFormat:@"%@", MPMusicPlayerController.iPodMusicPlayer.nowPlayingItem.albumTitle];
    }
    return newText;
}
@end

@implementation BlurImage
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGRect)size {
	//CGRect rect = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
	CGRect rect = size;
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);

	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return image;
}
-(void)touchedPlayButton {
    NSLog(@"MusicTest--play touched");
    //[MPMusicPlayerController.iPodMusicPlayer.nowPlayingItem setPlaybackState:MPMusicPlaybackStatePaused];
}
-(void)touchedBackButton {
    NSLog(@"MusicTest--back touched");
    //[MPMusicPlayerController.iPodMusicPlayer.nowPlayingItem skipToPreviousItem];
}
-(void)touchedNextButton {
    NSLog(@"MusicTest--next touched");
    //[MPMusicPlayerController.iPodMusicPlayer.nowPlayingItem skipToNextItem];
}/*
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
