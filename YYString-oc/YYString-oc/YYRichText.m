//
//  YYRichText.m
//  YYString-oc
//
//  Created by 符华友 on 2021/12/13.
//

#import "YYRichText.h"

@implementation YYRichText

- (void)setSubTexts:(NSArray *)texts
{
    _subTexts = texts;
    [self setAttributeText];
}

- (void)setAttributeText
{
    for (NSDictionary *textInfo in self.subTexts) {
        
//        UIFont *font = [textInfo objectForKey:
        
    }
    
}


@end
