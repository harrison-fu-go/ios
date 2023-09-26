//
//  ViewController.h
//  YYString-oc
//
//  Created by 符华友 on 2021/10/15.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, weak)IBOutlet UITextView *textView;

@property (nonatomic, weak)IBOutlet UILabel *lable;

@end




@interface NSString (YYString)

- (NSAttributedString *)attributedLh:(float)lineHeight font:(UIFont *)font color:(UIColor *)color;

@end
