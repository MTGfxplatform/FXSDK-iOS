//
//  ViewController.m
//  FXSDKSample
//
//  Created by FXMVP on 2021/10/6.
//

#import "ViewController.h"
#import <FX/FX.h>
#import <FX/FXEventConstants.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createBtn];
    self.title = @"test_page_title";
}

- (void)createBtn{
    UIButton *iapBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    iapBtn.backgroundColor = [UIColor yellowColor];
    [iapBtn setTitle:@"IAP Event" forState:UIControlStateNormal];
    iapBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [iapBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [iapBtn addTarget:self action:@selector(iapEventBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:iapBtn];
    
    
    UIButton *eventBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
    eventBtn.backgroundColor = [UIColor yellowColor];
    [eventBtn setTitle:@"Custom Event" forState:UIControlStateNormal];
    eventBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [eventBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [eventBtn addTarget:self action:@selector(eventBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:eventBtn];
}

- (void)iapEventBtnAction:(id)sender{

    FXEvent_IAP_Attribute_Item *item = [FXEvent_IAP_Attribute_Item new];
    item.name = @"name1";
    item.count = 1;

    FXEvent_IAP_Attribute_Item *item2 = [FXEvent_IAP_Attribute_Item new];
    item2.name = @"name2";
    item2.count = 2;
    
    
    FXEvent_IAP_Attribute *attribute = [[FXEvent_IAP_Attribute alloc] init];
    attribute.items = @[item,item2];
    attribute.amount = 28.54;
    attribute.currency = @"CNY";
    attribute.paystatus = FXEventConstant_IAP_PayStatus_success;
    attribute.transaction_id = @"1234554243";
    
    [[FXSDK sharedInstance] trackIAPWithAttributes:attribute];
    
}

- (void)eventBtnAction:(id)sender{

    NSDictionary *eventDic = [NSDictionary dictionaryWithObjectsAndKeys:
        @"111", @"key1",
        @"222", @"key2",
        @"333", @"key3", nil ];

    [[FXSDK sharedInstance] track:@"testEvent" withProperties:eventDic];
}




@end
