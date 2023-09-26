//
//  ViewController.m
//  YYString-oc
//
//  Created by 符华友 on 2021/10/15.
//

#import "ViewController.h"
#import "UILabel+YYEventLabel.h"
#import "GSRichTextLabel.h"
@interface ViewController ()

@property(nonatomic, weak)IBOutlet UITextField *textField;
@property(nonatomic, assign)CGFloat sH;
@property(nonatomic, assign)CGFloat sW;

@property(nonatomic, strong)UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.sH = [UIScreen mainScreen].bounds.size.height;
    self.sW = [UIScreen mainScreen].bounds.size.width;
    // Do any additional setup after loading the view.
    self.textField.text = @"12345678901";
    [self calculateTextHeight];
    self.view.backgroundColor = [UIColor grayColor];
    //富文本操作
//    [self testingAttributedString];
    float sWidth = [[UIScreen mainScreen] bounds].size.width;
    UIFont *font = [UIFont systemFontOfSize:14.0];
    GSRichTextLabel *lable = [[GSRichTextLabel alloc] initWithSubStrings:@[@{
        @"text":@"已经阅读并同意ffiudshfshfdsfhdskhfsjkhfd",
    },@{
        @"text":@"用户协议",
        @"color":[UIColor redColor],
        @"onClickEvent":@(YES),
    },@{
        @"text":@"与",
    },@{
        @"text":@"隐私政策是什么 fdskljflkajfla;fadkfja; fdajkfdjsa",
        @"color":[UIColor redColor],
        @"onClickEvent":@(YES),
    }] lineHeight:18 maxSize:CGSizeMake(sWidth, 200) defaultFont:font align:NSTextAlignmentLeft
                                                            defaultColor:[UIColor whiteColor]];
    CGRect frame = lable.frame;
    lable.frame = CGRectMake(0, 200, frame.size.width, frame.size.height);
    lable.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:lable];
}

//富文本操作
- (void)testingAttributedString
{
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 600, 400, 80)];
    self.label.numberOfLines = 0;
    [self.view addSubview:self.label];
    self.label.backgroundColor = [UIColor greenColor];
    NSDictionary *attributedDic = @{
        NSForegroundColorAttributeName: [UIColor redColor],
        NSFontAttributeName: [UIFont systemFontOfSize:18.00 weight:UIFontWeightSemibold],
    };
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"君不见黄河之水天上来，奔流到海不复回。君不见黄河之水天上来，奔流到海不复回。君不见黄河之水天上来，奔流到海不复回。" attributes:attributedDic];
    [string addAttributes:@{
        NSFontAttributeName:[UIFont systemFontOfSize:20.00],
        NSForegroundColorAttributeName: [UIColor whiteColor],
    } range:NSMakeRange(3, 2)];
    [string addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange(13, 5)];
    [string addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange(20, 5)];
    self.label.attributedText = string;
//    [self.label addTarget:self selector:@selector(onClick:) range:NSMakeRange(3, 2)];
//    [self.label addTarget:self selector:@selector(onClick:) range:NSMakeRange(13, 5)];
//    [self.label addTarget:self selector:@selector(onTap:) range:NSMakeRange(20, 5)];
}

- (void)onClick:(NSRange)range
{
    NSLog(@"========= on Click ==============");
}

- (void)onTap:(NSRange)range
{
    NSLog(@"========= on onTap ==============");
}



//这个是判断是否是手机号
- (IBAction)isPhoneNumber:(id)sender
{
    NSString *emailRegex = @"^\\d{11}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL is = [emailTest evaluateWithObject:self.textField.text];
    NSLog(@"======= is: %d", is);
}

//这个是计算文本高度
- (void)calculateTextHeight
{
    self.lable.attributedText = [self.lable.text attributedLh:16 font:self.lable.font color:[UIColor greenColor]];
    
    
    NSDictionary *attDic = [self.lable.attributedText attributesAtIndex:0 effectiveRange:nil];
    CGSize strSize = [self.lable.text boundingRectWithSize:CGSizeMake(375, 400)
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:attDic
                                                    context:nil].size;
    NSLog(@"===== %d, %d", (int)strSize.width, (int)strSize.height);
}


@end

@implementation NSString (YYString)


- (NSAttributedString *)attributedLh:(float)lineHeight font:(UIFont *)font color:(UIColor *)color
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.maximumLineHeight = lineHeight;
    paragraphStyle.minimumLineHeight = lineHeight;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CGFloat baselineOffset = (lineHeight - font.lineHeight) / 4;
    [attributes setObject:@(baselineOffset) forKey:NSBaselineOffsetAttributeName];
    [attributes setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:self attributes:attributes];
}

- (NSAttributedString *)attributedLh:(float)lineHeight
                                  fs:(float)fontSize
                                  fw:(UIFontWeight)fontWeight
                               color:(UIColor *)color
{
    UIFont *font = [UIFont systemFontOfSize:fontSize weight:fontWeight];
    return [self attributedLh:lineHeight font:font color:color];
}


@end
