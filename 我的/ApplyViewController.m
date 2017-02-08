//
//  ApplyViewController.m
//  AmericanMedical
//
//  Created by 王翼天 on 2017/2/7.
//  Copyright © 2017年 yb. All rights reserved.
//

#import "ApplyViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ApplyViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) TPKeyboardAvoidingScrollView* scrollView;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *sexTextField;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *birthdayTextField;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *cityTextField;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, copy) NSString *type;
@end

@implementation ApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigation];
    [self initScrollView];
    [self initButtonArray];
    [self initTextField];
    [self initSaveButton];
    self.type = @"";
    // Do any additional setup after loading the view.
}

- (void)initNavigation {
    self.navigationItem.title = @"申请";
    UIImage *back = [UIImage imageNamed:@"back"];
    back = [back imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:back style:UIBarButtonItemStyleDone target:self action:@selector(back)];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initScrollView {
    self.scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.bounds];
    [self.scrollView contentSizeToFit];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
}

- (void)initButtonArray {
    self.buttonArray = [NSMutableArray array];
    NSArray *titleArray = @[@"远程会诊",@"赴美就医",@"高端体检",@"精准医疗"];
    NSArray *imageArray = @[@"远程会诊",@"赴美医疗",@"精密体检",@"基因检测"];
    NSArray *imageSelectedArray = @[@"远程会诊_s",@"赴美就医_s",@"高端体检_s",@"精准医疗_s"];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageSelectedArray[i]] forState:UIControlStateSelected];
        CGFloat btnX = ScreenWidth/4*i + (ScreenWidth/4-60)/2;
        btn.frame = CGRectMake(btnX, 16, 60, 60);
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(type:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        [self.buttonArray addObject:btn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/4*i, 76 + 8, ScreenWidth/4, 16)];
        label.text = titleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        [self.scrollView addSubview:label];
    }
}

- (void)initTextField {
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 110 + 16, 60, 36)];
    nameLabel.text = @"姓名";
    nameLabel.font = [UIFont systemFontOfSize:13];
    [self.scrollView addSubview:nameLabel];
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 110 + 16, ScreenWidth - 100 - 50, 36)];
    [self addAttrsForTextField:self.nameTextField placeholder:@"真实姓名"];
    [self.scrollView addSubview:self.nameTextField];
    
    UILabel *sexlabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 110 + 16 + (36+16)*1, ScreenWidth - 100 - 50, 36)];
    sexlabel.text = @"性别";
    sexlabel.font = [UIFont systemFontOfSize:13];
    [self.scrollView addSubview:sexlabel];
    self.sexTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 110 + 16 + (36+16)*1, ScreenWidth - 100 - 50, 36)];
    [self addAttrsForTextField:self.sexTextField placeholder:@"输入性别"];
    [self.scrollView addSubview:self.sexTextField];
    
    UILabel *phonelabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 110 + 16 + (36+16)*2, ScreenWidth - 100 - 50, 36)];
    phonelabel.text = @"手机号码";
    phonelabel.font = [UIFont systemFontOfSize:13];
    [self.scrollView addSubview:phonelabel];
    self.phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 110 + 16 + (36+16)*2, ScreenWidth - 100 - 50, 36)];
    [self addAttrsForTextField:self.phoneTextField placeholder:@"输入手机号码"];
    [self.scrollView addSubview:self.phoneTextField];
    
    UILabel *birthdaylabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 110 + 16 + (36+16)*3, ScreenWidth - 100 - 50, 36)];
    birthdaylabel.text = @"出生日期";
    birthdaylabel.font = [UIFont systemFontOfSize:13];
    [self.scrollView addSubview:birthdaylabel];
    self.birthdayTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 110 + 16 + (36+16)*3, ScreenWidth - 100 - 50, 36)];
    [self addAttrsForTextField:self.birthdayTextField placeholder:@"出生日期"];
    [self.scrollView addSubview:self.birthdayTextField];
    
    UILabel *emaillabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 110 + 16 + (36+16)*4, ScreenWidth - 100 - 50, 36)];
    emaillabel.text = @"邮箱地址";
    emaillabel.font = [UIFont systemFontOfSize:13];
    [self.scrollView addSubview:emaillabel];
    self.emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 110 + 16 + (36+16)*4, ScreenWidth - 100 - 50, 36)];
    [self addAttrsForTextField:self.emailTextField placeholder:@"输入邮箱地址"];
    [self.scrollView addSubview:self.emailTextField];
    
    UILabel *citylabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 110 + 16 + (36+16)*5, ScreenWidth - 100 - 50, 36)];
    citylabel.text = @"居住城市";
    citylabel.font = [UIFont systemFontOfSize:13];
    [self.scrollView addSubview:citylabel];
    self.cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 110 + 16 + (36+16)*5, ScreenWidth - 100 - 50, 36)];
     [self addAttrsForTextField:self.cityTextField placeholder:@"居住城市"];
    [self.scrollView addSubview:self.cityTextField];
}

- (void)initSaveButton {
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveButton.backgroundColor = [UIColor colorWithRed:105/255.0 green:191/255.0 blue:237/255.0 alpha:1.0];
    self.saveButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.saveButton setTitle:@"提 交" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveButton.frame = CGRectMake(45, CGRectGetMaxY(self.cityTextField.frame)+50, ScreenWidth-45*2, 36);
    [self.saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.saveButton];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(self.saveButton.frame)+50);
}

- (void)type:(UIButton*)btn {
    if (btn.selected) {
        btn.selected = NO;
        self.type = @"";
    } else {
        for (UIButton *button in self.buttonArray) {
            button.selected = NO;
        }
        btn.selected = YES;
        self.type = [NSString stringWithFormat:@"%ld",btn.tag-1000];
    }
}

- (void)save {
    if (self.type.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (self.nameTextField.text.length && self.sexTextField.text.length && self.phoneTextField.text.length && self.birthdayTextField.text.length && self.emailTextField.text.length && self.cityTextField.text.length) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
        NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
        [paramter setObject:self.nameTextField.text forKey:@"username"];
        [paramter setObject:self.sexTextField.text forKey:@"gender"];
        [paramter setObject:self.phoneTextField.text forKey:@"number"];
        [paramter setObject:self.birthdayTextField.text forKey:@"birthday"];
        [paramter setObject:self.emailTextField.text forKey:@"email"];
        [paramter setObject:self.cityTextField.text forKey:@"lead_address"];
        [paramter setObject:self.type forKey:@"type"];
        [session GET:@"" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
}

- (void)addAttrsForTextField:(UITextField*)textField placeholder:(NSString*)placeholder {
    textField.placeholder = placeholder;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 2;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 5)];
    textField.leftView = view;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

@end
