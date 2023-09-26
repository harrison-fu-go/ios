//
//  YYLabel.h
//  YYString-oc
//
//  Created by 符华友 on 2021/12/13.
//

#import <UIKit/UIKit.h>
#import "NSString+GS.h"

@interface GSRichTextLabel : UILabel

@property(nonatomic, strong)void (^onClick)(NSString* identifier);

- (instancetype)initWithSubStrings:(NSArray *)subStrings
                        lineHeight:(float)lineHeight
                           maxSize:(CGSize)maxSize
                       defaultFont:(UIFont *)defaultFont
                             align:(NSTextAlignment)align
                      defaultColor:(UIColor *)color;


@end
