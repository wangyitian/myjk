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
#import "DatePickerView.h"
#import "CityPickerView.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define AlertTag    2000
#define ButtonTag   1000
#define LabelTag    3000
#define ApplyURL    @"http://www.meiyujiankang.com/api/service.php"
@interface ApplyViewController ()<UIScrollViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) TPKeyboardAvoidingScrollView* scrollView;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *genderArray;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *birthdayTextField;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *cityTextField;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, strong) DatePickerView *datePickerView;
@property (nonatomic, strong) CityPickerView *cityPickerView;
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
    self.gender = @"";
    // Do any additional setup after loading the view.
}

- (void)initNavigation {
    self.navigationItem.title = @"申 请";
    UIImage *back = [UIImage imageNamed:@"back"];
    back = [back imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:back forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 20, 70, 44);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(12, 9, 12, 49);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
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
    self.genderArray = [NSMutableArray array];
    NSArray *titleArray = @[@"远程会诊",@"赴美就医",@"高端体检",@"精准医疗"];
    NSArray *imageArray = @[@"远程会诊",@"赴美医疗",@"精密体检",@"基因检测"];
    NSArray *imageSelectedArray = @[@"远程会诊_selected",@"赴美就医_selected",@"高端体检_selected",@"精准医疗_selected"];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageSelectedArray[i]] forState:UIControlStateSelected];
        CGFloat btnX = ScreenWidth/4*i + (ScreenWidth/4-60)/2;
        btn.frame = CGRectMake(btnX, 16, 60, 60);
        btn.tag = ButtonTag + i;
        [btn addTarget:self action:@selector(type:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        [self.buttonArray addObject:btn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/4*i, 76 + 8, ScreenWidth/4, 16)];
        label.text = titleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.tag = LabelTag + i;
        [self.scrollView addSubview:label];
    }
}

- (void)initTextField {
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 110 + 16, 60, 36)];
    nameLabel.text = @"姓名:";
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.textColor = [UIColor grayColor];
    [self.scrollView addSubview:nameLabel];
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 110 + 16, ScreenWidth - 110 - 30, 36)];
    [self addAttrsForTextField:self.nameTextField placeholder:@"真实姓名"];
    [self.scrollView addSubview:self.nameTextField];
    
    UILabel *sexlabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 110 + 16 + (36+16)*1, 60, 36)];
    sexlabel.text = @"性别:";
    sexlabel.font = [UIFont systemFontOfSize:13];
    sexlabel.textColor = [UIColor grayColor];
    [self.scrollView addSubview:sexlabel];
    UIButton *manButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [manButton setImage:[UIImage imageNamed:@"选择套餐圆圈"] forState:UIControlStateNormal];
    [manButton setImage:[UIImage imageNamed:@"选择套餐圆圈（选中后）"] forState:UIControlStateSelected];
    [manButton setTitle:@" 男" forState:UIControlStateNormal];
    manButton.titleLabel.font = [UIFont systemFontOfSize:13];
    manButton.tag = 7000;
    [manButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [manButton addTarget:self action:@selector(genderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    manButton.frame = CGRectMake(110, 110 + 16 + (36+16)*1, 50, 39);
    [self.scrollView addSubview:manButton];
    UIButton *womanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [womanButton setImage:[UIImage imageNamed:@"选择套餐圆圈"] forState:UIControlStateNormal];
    [womanButton setImage:[UIImage imageNamed:@"选择套餐圆圈（选中后）"] forState:UIControlStateSelected];
    [womanButton setTitle:@" 女" forState:UIControlStateNormal];
    womanButton.titleLabel.font = [UIFont systemFontOfSize:13];
    womanButton.tag = 7001;
    [womanButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [womanButton addTarget:self action:@selector(genderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    womanButton.frame = CGRectMake(170, 110 + 16 + (36+16)*1, 50, 39);
    [self.scrollView addSubview:womanButton];
    [self.genderArray addObject:manButton];
    [self.genderArray addObject:womanButton];
    
    UILabel *phonelabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 110 + 16 + (36+16)*2, 60, 36)];
    phonelabel.text = @"手机号码:";
    phonelabel.font = [UIFont systemFontOfSize:13];
    phonelabel.textColor = [UIColor grayColor];
    [self.scrollView addSubview:phonelabel];
    self.phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 110 + 16 + (36+16)*2, ScreenWidth - 110 - 30, 36)];
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addAttrsForTextField:self.phoneTextField placeholder:@"输入手机号码"];
    [self.scrollView addSubview:self.phoneTextField];
    
    UILabel *birthdaylabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 110 + 16 + (36+16)*3, 60, 36)];
    birthdaylabel.text = @"出生日期:";
    birthdaylabel.font = [UIFont systemFontOfSize:13];
    birthdaylabel.textColor = [UIColor grayColor];
    [self.scrollView addSubview:birthdaylabel];
    self.birthdayTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 110 + 16 + (36+16)*3, ScreenWidth  - 110 - 30, 36)];
    [self addAttrsForTextField:self.birthdayTextField placeholder:@"出生日期"];
    [self.scrollView addSubview:self.birthdayTextField];
    
    UILabel *emaillabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 110 + 16 + (36+16)*4, 60, 36)];
    emaillabel.text = @"邮箱地址:";
    emaillabel.font = [UIFont systemFontOfSize:13];
    emaillabel.textColor = [UIColor grayColor];
    [self.scrollView addSubview:emaillabel];
    self.emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 110 + 16 + (36+16)*4, ScreenWidth - 110 - 30, 36)];
    [self addAttrsForTextField:self.emailTextField placeholder:@"输入邮箱地址"];
    [self.scrollView addSubview:self.emailTextField];
    
    UILabel *citylabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 110 + 16 + (36+16)*5, 60, 36)];
    citylabel.text = @"居住城市:";
    citylabel.font = [UIFont systemFontOfSize:13];
    citylabel.textColor = [UIColor grayColor];
    [self.scrollView addSubview:citylabel];
    self.cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 110 + 16 + (36+16)*5, ScreenWidth - 110 - 30, 36)];
     [self addAttrsForTextField:self.cityTextField placeholder:@"居住城市"];
    [self.scrollView addSubview:self.cityTextField];
}

- (void)initSaveButton {
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveButton.backgroundColor = [UIColor colorWithRed:105/255.0 green:191/255.0 blue:237/255.0 alpha:1.0];
    self.saveButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.saveButton setTitle:@"提 交" forState:UIControlStateNormal];
    self.saveButton.layer.masksToBounds = YES;
    self.saveButton.layer.cornerRadius = 3;
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveButton.frame = CGRectMake(45, CGRectGetMaxY(self.cityTextField.frame)+30, ScreenWidth-45*2, 36);
    [self.saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.saveButton];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(self.saveButton.frame)+50);
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.birthdayTextField) {
        [self removeKeyboard];
        if (!self.datePickerView) {
            self.datePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 190, ScreenWidth, 190)];
            
            __block typeof(self) weakSelf = self;
            self.datePickerView.cancelBlock = ^{
                [weakSelf.datePickerView removeFromSuperview];
            };
            self.datePickerView.confirmBlock = ^(NSString *date) {
                weakSelf.birthdayTextField.text = date;
                [weakSelf.datePickerView removeFromSuperview];
            };
        }
        [self.cityPickerView removeFromSuperview];
        [self.view addSubview:self.datePickerView];
        return NO;
        
    } else if (textField == self.cityTextField) {
        [self removeKeyboard];
        if (!self.cityPickerView) {
            self.cityPickerView = [[CityPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 190, ScreenWidth, 190)];
            __block typeof(self) weakSelf = self;
            self.cityPickerView.cancelBlock = ^{
                [weakSelf.cityPickerView removeFromSuperview];
            };
            self.cityPickerView.confirmBlock = ^(NSString *city) {
                weakSelf.cityTextField.text = city;
                [weakSelf.cityPickerView removeFromSuperview];
            };
        }
        [self.datePickerView removeFromSuperview];
        [self.view addSubview:self.cityPickerView];
        return NO;
    }
    return YES;
}

- (void)type:(UIButton*)btn {
    if (btn.selected) {
        btn.selected = NO;
        self.type = @"";
        UILabel *label = [self.view viewWithTag:btn.tag - ButtonTag + LabelTag];
        label.textColor = [UIColor blackColor];
    } else {
        for (UIButton *button in self.buttonArray) {
            button.selected = NO;
            UILabel *label = [self.view viewWithTag:button.tag - ButtonTag + LabelTag];
            label.textColor = [UIColor blackColor];
        }
        btn.selected = YES;
        self.type = [NSString stringWithFormat:@"%ld",btn.tag-ButtonTag+1];
        UILabel *label = [self.view viewWithTag:btn.tag - ButtonTag + LabelTag];
        label.textColor = [UIColor colorWithRed:105/255.0 green:191/255.0 blue:237/255.0 alpha:1.0];
    }
}

- (void)genderButtonAction:(UIButton*)btn {
    [self removeKeyboard];
    if (btn.selected) {
        btn.selected = !btn.selected;
        self.gender = @"";
    } else {
        if (btn.tag == 7000) {
            btn.selected = YES;
            self.gender = @"男";
            UIButton *button = [self.view viewWithTag:7001];
            button.selected = NO;
        } else {
            btn.selected = YES;
            self.gender = @"女";
            UIButton *button = [self.view viewWithTag:7000];
            button.selected = NO;
        }
    }
}

- (void)save {
    if (self.type.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (self.nameTextField.text.length && self.phoneTextField.text.length && self.gender.length && self.birthdayTextField.text.length && self.emailTextField.text.length && self.cityTextField.text.length) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
        NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
        [paramter setObject:self.nameTextField.text forKey:@"realname"];
        [paramter setObject:self.gender forKey:@"gender"];
        [paramter setObject:self.phoneTextField.text forKey:@"mymobile"];
        [paramter setObject:self.birthdayTextField.text forKey:@"birthday"];
        [paramter setObject:self.emailTextField.text forKey:@"myemail"];
        [paramter setObject:self.cityTextField.text forKey:@"lead_address"];
        [paramter setObject:[NSString stringWithFormat:@"id%@",self.type] forKey:@"type"];
        [session GET:ApplyURL parameters:paramter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *res = (NSDictionary*)responseObject;
            if ([res[@"status"] isEqualToString:@"0"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:res[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            } else if ([res[@"status"] isEqualToString:@"1"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:res[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alert.delegate = self;
                alert.tag = AlertTag;
                [alert show];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求失败，请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertTag) {
        self.nameTextField.text = @"";
        self.gender = @"";
        self.phoneTextField.text = @"";
        self.birthdayTextField.text = @"";
        self.emailTextField.text = @"";
        self.cityTextField.text = @"";
        for (UIButton *btn in self.buttonArray) {
            btn.selected = NO;
            self.type = @"";
            UILabel *label = [self.view viewWithTag:btn.tag - ButtonTag + LabelTag];
            label.textColor = [UIColor blackColor];
        }
        for (UIButton *btn in self.genderArray) {
            btn.selected = NO;
        }
    }
}

- (void)removeKeyboard {
    [self.birthdayTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.cityTextField resignFirstResponder];
}

- (void)addAttrsForTextField:(UITextField*)textField placeholder:(NSString*)placeholder {
    textField.placeholder = placeholder;
    textField.layer.borderColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0].CGColor;
    textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 2;
    textField.delegate = self;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 5)];
    textField.leftView = view;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

@end
