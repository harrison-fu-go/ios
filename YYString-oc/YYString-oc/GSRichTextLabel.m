//
//  YYLabel.m
//  YYString-oc
//
//  Created by 符华友 on 2021/12/13.
//

#import "GSRichTextLabel.h"
#import "UILabel+YYEventLabel.h"
@interface GSRichTextLabel()
@property(nonatomic, strong)NSMutableArray *locs;
@property(nonatomic, strong)NSMutableArray *iRanges;
@end
@implementation GSRichTextLabel

- (instancetype)initWithSubStrings:(NSArray *)subStrings
                        lineHeight:(float)lineHeight
                           maxSize:(CGSize)maxSize
                       defaultFont:(UIFont *)defaultFont
                             align:(NSTextAlignment)align
                      defaultColor:(UIColor *)color
{
    if (self = [super init]) {
        self.iRanges = [NSMutableArray array];
        NSMutableArray *subTexts = [NSMutableArray array];
        NSMutableString *text = [NSMutableString string];
        for (NSDictionary *strDic in subStrings) {
            NSString *str = [strDic objectForKey:@"text"];
            [subTexts addObject:str];
            [text appendString:str];
        }
        CGSize agrrementSize = [text sizeWithLH:lineHeight font:defaultFont maxSize:maxSize];
        self.frame = CGRectMake(0, 0, agrrementSize.width, agrrementSize.height);
        NSAttributedString *attributeText = [text attributedLh:lineHeight font:defaultFont color:color];
        NSMutableAttributedString *mutableAttText = [[NSMutableAttributedString alloc] initWithAttributedString:attributeText];
        
        //设置每一个的显示
        int loc = 0;
        for (int index = 0; index<subStrings.count; index++) {
            NSDictionary *strDic = subStrings[index];
            NSString *str = [strDic objectForKey:@"text"];
            UIFont *font = [strDic objectForKey:@"font"];
            UIFont *color = [strDic objectForKey:@"color"];
            BOOL isClick = [[strDic objectForKey:@"onClickEvent"] boolValue];
            int len = (int)str.length;
            NSRange range = NSMakeRange(loc, len);
            NSMutableDictionary *attributeDic = [NSMutableDictionary dictionary];
            if (font) {
                [attributeDic setObject:font forKey:NSFontAttributeName];
            }
            if (color) {
                [attributeDic setObject:color forKey:NSForegroundColorAttributeName];
            }
            [mutableAttText addAttributes:attributeDic range:range];
            if (isClick) {
                [self.iRanges addObject:[NSValue valueWithRange:range]];
            }
            loc = loc + len;
        }
        self.attributedText = mutableAttText;
        self.numberOfLines = 0;
        self.textAlignment = align;
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.lineBreakMode = NSLineBreakByCharWrapping;
    self.numberOfLines = 0;
}


- (void)setOnClick:(void (^)(NSString *))onClick
{
    _onClick = onClick;
    for (int index = 0; index<self.iRanges.count; index++) {
        NSValue *rangeVal = [self.iRanges objectAtIndex:index];
        NSRange range = [rangeVal rangeValue];
        [self addTarget:self
               selector:@selector(onClick:)
                  range:range
             identifier:@(index).stringValue];
    }
}

- (void)onClick:(NSString *)identifier
{
    if (self.onClick) {
        self.onClick(identifier);
    }
}

- (void)dealloc
{
    _onClick = nil;
}
@end
