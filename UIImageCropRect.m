#import "UIImageCropRect.h"

@implementation UIImage (CropRect)
- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {

    CGImageRef maskRef = maskImage.CGImage; 

    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
        CGImageGetHeight(maskRef),
        CGImageGetBitsPerComponent(maskRef),
        CGImageGetBitsPerPixel(maskRef),
        CGImageGetBytesPerRow(maskRef),
        CGImageGetDataProvider(maskRef), NULL, false);

    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];

    CGImageRelease(mask);
    CGImageRelease(maskedImageRef);

    // returns new image with mask applied
    return maskedImage;
}
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)c {
    CGRect r = CGContextGetClipBoundingBox(c);
    //CGRect r2 = CGRectInset(r, r.size.width/2.0 - 10, r.size.height/2.0 - 10);
    CGRect r2 = CGRectInset(r, 0.5, 0.5);

    UIImage* maskim;
    {
        UIGraphicsBeginImageContextWithOptions(r.size, NO, 0);
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextAddEllipseInRect(c, r2);
        CGContextAddRect(c, r);
        CGContextEOClip(c);
        CGContextSetFillColorWithColor(c, [UIColor blackColor].CGColor);
        CGContextFillRect(c, r);
        maskim = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }

    CALayer* mask = [CALayer layer];
    mask.frame = r;
    mask.contents = (id)maskim.CGImage;
    layer.mask = mask;
}
@end