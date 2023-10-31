//
//  ViewController.m
//  testlatex
//
//  Created by fs0011 on 2023/10/31.
//

#import "ViewController.h"
#import <MTMathAtomFactory.h>
#import <IosMath.h>
#import <Masonry.h>
#import <MathEditor-umbrella.h>
#import <TYTextStorage.h>
#import <TYTextContainer.h>
#import <TYAttributedLabel.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MTMathAtomFactory addLatexSymbol:@"\\"
                                value:[MTMathAtomFactory operatorWithName:@"\\" limits:NO]];
   
//    [self.view addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(100);
//        make.top.mas_equalTo(100);
//    }];
    NSLog(@"加载完成");
    
    
    
    NSString *text = @"<p>已知函数\\(f(x)=\\frac{\\sqrt{3}}{2}\\sin 2x-{{\\cos }^{2}}x-\\frac{1}{2}\\)，\\((x\\in R)\\)</p> <p>\\((I)\\)求函数\\(f(x)\\)的最小值和最小正周期；</p> <p>\\((II)\\)设\\(\\Delta ABC\\)的内角\\(A,B,C\\)的对边分别为\\(a,b,c\\)，且\\(c=\\sqrt{3}\\)，\\(f(C)=0\\)，若向量\\( \\overrightarrow{m}=\\left(1,\\sin A\\right) \\)与向量\\( \\overrightarrow{n}=\\left(2,\\sin B\\right) \\)共线，求\\(a,b\\)的值．</p>";
    NSLog(@"%@",text);
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
        textContainer.text = text;
        // 文字间隙
    textContainer.characterSpacing = 2;
    // 文本行间隙
    textContainer.linesSpacing = 5;
    
    
    
    
    
    // 生成 textContainer 文本容器
    [textContainer createTextContainerWithTextWidth:CGRectGetWidth(self.view.frame)];

    TYAttributedLabel *label1 = [[TYAttributedLabel alloc]init];
    label1.textContainer = textContainer;
    [label1 setFrameWithOrign:CGPointMake(0, 100) Width:CGRectGetWidth(self.view.frame)];
    [self.view addSubview:label1];
    
//    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(50);
//        make.top.mas_equalTo(50);
//        make.width.mas_equalTo(375-100);
//    }];
//    [label1.superview layoutIfNeeded];
    NSString *pattern = @"\\\\\\(.*?\\\\\\)"; // 用于匹配 \(...\) 的正则表达式
    NSError *regexError = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&regexError];

    if (!regexError) {
        NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
        
        for (NSTextCheckingResult *match in matches) {
            NSRange matchRange = [match range];
            NSString *matchedString = [text substringWithRange:matchRange];

            // 创建并配置 MTMathUILabel
            MTMathUILabel *mathLabel = [[MTMathUILabel alloc] init];
            
            NSString *latexString = [matchedString stringByReplacingOccurrencesOfString:@"\\(" withString:@""];
                   latexString = [latexString stringByReplacingOccurrencesOfString:@"\\)" withString:@""];
            mathLabel.latex = latexString;
            [mathLabel sizeToFit];

            // 为 MTMathUILabel 创建 TYViewStorage
            TYViewStorage *storage = [TYViewStorage new];
            storage.view = mathLabel;
            storage.range = matchRange; // 设置原始 LaTeX 字符串的范围
            storage.drawAlignment = TYDrawAlignmentCenter;

            // 将 storage 添加到 label1
            [label1 addTextStorage:storage];
        }
    } else {
        NSLog(@"正则表达式错误: %@", regexError.localizedDescription);
    }
    
//    MTMathUILabel* label = [[MTMathUILabel alloc] init];
//    
//    label.labelMode = kMTMathUILabelModeText;
//    
//
//    
//    
//    label.latex = @"f(x)=\\frac{\\sqrt{3}}{2}\\sin 2x-{{\\cos }^{2}}x-\\frac{1}{2}";
//    [label sizeToFit];
//    label.frame = CGRectMake(0, 0, label.bounds.size.width, label.bounds.size.height);
//    
//    TYViewStorage* st  = [TYViewStorage new];
//    st.view = label;
//    st.range = [text rangeOfString:label.latex];
//    st.drawAlignment = TYDrawAlignmentCenter;
//    
//    [label1 addTextStorage:st];
    // 也可以 生成NSAttributedString 属性文本
    //NSAttributedString *attString = [textContainer createAttributedString];
    //label.attributedText = attString;

//    [label1 setFrameWithOrign:CGPointZero Width:CGRectGetWidth(self.view.frame)];
    
    // Do any additional setup after loading the view.
}


@end
