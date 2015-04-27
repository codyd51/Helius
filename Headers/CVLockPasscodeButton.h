//
//  CVLockPasscodeButton.h
//  Convergance
//
//  Created by Matt Clarke on 05/10/2013.
//
//

#import <UIKit/UIKit.h>

@interface CVLockPasscodeButton : UIButton

@property (nonatomic, retain) UILabel *numberLabel;
@property (readwrite) int num;
@property (nonatomic, retain) UILabel *letters;
@property (nonatomic, retain) UIImageView *highlightimg;

-(void)initWithButtonNumber:(int)number;

@end
