//
//  NTUIKit
//
//  Created by HarrisonFu on 2023/8/11.
//

#import <UIKit/UIKit.h>

@interface UILabel (EventTap)

- (NSArray *)lines;

- (void)addTarget:(id)target
         selector:(SEL)sel
            range:(NSRange)range
       identifier:(NSString *)identifier;

@end

