//
//  CVLockPasscodeView.h
//  Convergance
//
//  Created by Matt Clarke on 05/10/2013.
//
//

#import <UIKit/UIKit.h>
#import "CVLockPasscodeButton.h"
#import "CVLockPasscodeTextView.h"

@class CVReactiveButton, UIKeyboard;

@interface CVLockPasscodeView : UIView

@property (nonatomic, retain) CVReactiveButton *emergency;
@property (nonatomic, retain) CVReactiveButton *del;
@property (nonatomic, retain) UIImageView *delOrCancel;
@property (nonatomic, retain) UIView *dotContainer;
@property (nonatomic, strong) CVLockPasscodeTextView *hiddenText;

@property (readwrite) int passcodeLength;
@property (nonatomic, retain) NSMutableString *passcode;
@property (nonatomic, copy) NSDictionary *passcodeInfo;
@property (readwrite) BOOL isNumberPasscode;
@property (readwrite) BOOL deleteButtonShowing;
@property (readwrite) BOOL needsOkayButton;

@property (nonatomic, strong) UIKeyboard *kb;

-(void)checkPasscode:(id)sender;
-(void)passcodeCheckSucceeded;
-(void)deleteButtonWasPressed:(id)button;

-(void)changeDelOrCancelButtonImageToVariant:(int)variant;
-(void)phoneHome:(BOOL)arg1;
-(void)addAnotherDotWithTag:(int)i;

@end
