//
//  SignInCommerceImageViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 6/12/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "SignInCommerceImageViewController.h"
#import "BottomBorderTextField.h"
#import "UIColor+UIColor.h"
#import "SignInBankAccountViewController.h"
#import "NavigationController.h"

@interface SignInCommerceImageViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileCommerceImage;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *tablesQuantity;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *uploadLabel;
@property (nonatomic, strong) UIImage *imageSelected;

@end

@implementation SignInCommerceImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    self.tablesQuantity.delegate = self;
    self.tablesQuantity.placeholder = NSLocalizedString(@"tablesQuantityPlaceholder", nil);
    self.infoLabel.text = NSLocalizedString(@"tablesInfoLabel", nil);
    [self.nextButton setTitle:NSLocalizedString(@"nextAction", nil) forState:UIControlStateNormal];
    self.nextButton.layer.cornerRadius = 20.f;
    self.profileCommerceImage.layer.cornerRadius = self.profileCommerceImage.frame.size.width / 2;
    self.profileCommerceImage.layer.borderWidth = 2.f;
    self.profileCommerceImage.layer.borderColor = [UIColor grayBackgroundViewColor].CGColor;
    NSMutableAttributedString *uploadPhoto = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"uploadLogoAction", nil)];
    [uploadPhoto addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[uploadPhoto length]}];
    self.uploadLabel.attributedText = uploadPhoto;
    [self setGestures];
}

- (void)setGestures {
    UITapGestureRecognizer *labelGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadPhotoAction)];
    UITapGestureRecognizer *imageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadPhotoAction)];
    [self.profileCommerceImage addGestureRecognizer:imageGesture];
    [self.uploadLabel addGestureRecognizer:labelGesture];
    [self.profileCommerceImage setMultipleTouchEnabled:YES];
    self.profileCommerceImage.userInteractionEnabled = YES;
    self.uploadLabel.userInteractionEnabled = YES;
}

#pragma mark - Textfield delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark actions
- (IBAction)nextAction:(id)sender {
    SignInBankAccountViewController *viewController = (SignInBankAccountViewController *)
    [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInBankAccountViewController"];
    self.user.userType = [self.tablesQuantity.text integerValue] > 0 ? RestaurantNavigation : CommerceNavigation;
    viewController.user = self.user;
    viewController.commerceLogo = self.imageSelected;
    viewController.tables = [self.tablesQuantity.text integerValue];
    [self.navigationController pushViewController:viewController animated:true];
}



- (void)uploadPhotoAction {
    [self openGallery];
}

- (void)openGallery{
    UIImagePickerController *picker;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.uploadLabel.hidden = YES;
    self.profileCommerceImage.image = image;
    self.imageSelected = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
