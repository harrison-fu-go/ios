//
//  YYRichText.h
//  YYString-oc
//
//  Created by 符华友 on 2021/12/13.
//

#import <Foundation/Foundation.h>

@interface YYRichText : NSObject

@property(nonatomic, strong)NSArray *subTexts;

@property(nonatomic, strong)NSMutableAttributedString *text;

//texts: [{"font":UIFont, "text":string},...]
- (void)setSubTexts:(NSArray *)subTexts;

@end

