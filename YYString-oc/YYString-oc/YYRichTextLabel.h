//
//  YYLabel.h
//  YYString-oc
//
//  Created by 符华友 on 2021/12/13.
//

#import <UIKit/UIKit.h>


@interface YYRichTextLabel : UILabel

@property(nonatomic, strong)void (^onClick)(int index);

- (void)setTextWithSubTexts:(NSArray *)textInfos;

@end


