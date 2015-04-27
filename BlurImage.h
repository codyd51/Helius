@interface BlurImage : NSObject
+ (UIImage*)imageWithColor:(UIColor*)color andSize:(CGRect)rect;
@end
@interface UIImage (CustomAlpha)
- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha;
@end
@interface UIImageView (CutHole)
-(void)cutHoleInImageView:(UIImageView*)imageView withSize:(CGRect)rect;
@end
