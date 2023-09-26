//
//  YYLabel.m
//  YYString-oc
//
//  Created by 符华友 on 2021/12/13.
//

#import "YYRichTextLabel.h"
#import "UILabel+YYEventLabel.h"
@interface YYRichTextLabel()
@property(nonatomic, strong)NSMutableArray *locs;
@end
@implementation YYRichTextLabel

- (void)setTextWithSubTexts:(NSArray *)textInfos
{
    self.locs = [NSMutableArray array];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    NSMutableArray *lens = [NSMutableArray array];
    for(NSDictionary *textInfo in textInfos) {
        NSString *text = [textInfo objectForKey:@"text"];
        NSDictionary *attribute = [textInfo objectForKey:@"attribute"];
        NSMutableAttributedString *tem = [[NSMutableAttributedString alloc] initWithString:text attributes:attribute];
        [string appendAttributedString:tem];
        [lens addObject:@(text.length)];
    }
    self.attributedText = string;
    NSUInteger loc = 0;
    for (NSNumber *val in lens) {
        [self.locs addObject:@(loc)];
        NSUInteger len = [val integerValue];
//        [self addTarget:self selector:@selector(didClick:) range:NSMakeRange(loc, len)];
        loc = loc + len;
    }
}

- (void)didClick:(NSRange)range
{
    for(int index = 0; index<self.locs.count; index++) {
        NSNumber *locNum = [self.locs objectAtIndex:index];
        NSUInteger loc = [locNum integerValue];
        if (loc == range.location) {
            if (self.onClick) {
                self.onClick(index);
            }
        }
    }
}

- (void)dealloc
{
    self.onClick = nil;
}
@end
