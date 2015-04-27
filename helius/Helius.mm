#import <Preferences/Preferences.h>
#define url(x) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:x]];

@interface HeliusListController: PSListController {
}
-(void)openTwitter;
@end

@implementation HeliusListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Helius" target:self] retain];
	}
	return _specifiers;
}
- (void)openTwitter {
    url(@"http://twitter.com/phillipten");
}
@end

// vim:ft=objc
