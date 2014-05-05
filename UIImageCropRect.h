@interface UIImage (CropRect)

//- (UIImage *)cropWithRect:(CGRect)rect;
- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage;
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)c;

@end