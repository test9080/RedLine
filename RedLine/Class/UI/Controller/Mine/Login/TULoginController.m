//
//  TULoginController.m
//  RedLine
//
//  Created by LXJ on 16/4/21.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TULoginController.h"
#import "TURegisterController.h"

@interface TULoginController ()


@end

@implementation TULoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)cancelVC:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)gotoRegister:(UIButton *)sender {
    TURegisterController *registerVC = [[TURegisterController alloc] initWithNibName:@"TURegisterController" bundle:nil];
    [self presentViewController:registerVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
