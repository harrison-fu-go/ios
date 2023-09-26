//
//  UILabel+YYEventLabel.h
//  YYString-oc
//
//  Created by 符华友 on 2021/11/12.
//

#import <UIKit/UIKit.h>

@interface UILabel (YYEventLabel)

- (NSArray *)lines;

- (void)addTarget:(id)target
         selector:(SEL)sel
            range:(NSRange)range
       identifier:(NSString *)identifier;

@end

