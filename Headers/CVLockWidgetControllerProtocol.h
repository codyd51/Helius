@protocol CVLockWidgetController <NSObject>
@required
-(id)view;
-(float)viewHeight;

@optional // I'll implement these eventually
-(void)viewWillDisappear;
-(void)viewDidAppear;
-(void)unloadPresentationController;
-(id)presentationControllerForMode:(int)mode;
-(void)loadView;
-(void)clearShapshotImage;
-(void)unloadView;
-(void)didRotateFromInterfaceOrientation:(int)interfaceOrientation;
-(void)willAnimateRotationToInterfaceOrientation:(int)interfaceOrientation;
-(void)willRotateToInterfaceOrientation:(int)interfaceOrientation;
-(void)viewDidDisappear;
-(void)viewWillAppear;
@end