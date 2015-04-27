//
//  CVLockFeedWidget.h
//  Convergance
//
//  Created by Matt Clarke on 03/08/2013.
//
//

#import <UIKit/UIKit.h>
#import "CVLockWidgetControllerProtocol.h"

@interface CVLockFeedWidget : UIView

@property (nonatomic, retain) NSBundle *bundle;
@property (nonatomic, strong) UIWebView *view;
@property (nonatomic, strong) NSObject <CVLockWidgetController> *widget;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIView *viw;

-(id)initWithWidget:(NSString*)identifier;
@end
