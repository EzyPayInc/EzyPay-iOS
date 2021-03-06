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

@interface SignInCommerceImageViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *profileCommerceImage;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *tablesQuantity;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *uploadLabel;
@property (nonatomic, strong) UIImage *imageSelected;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerTables;

@property (nonatomic, assign) NSInteger tables;

@end

@implementation SignInCommerceImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    self.tables = 0;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[self.pickerTables.subviews objectAtIndex:1] setHidden:YES];
    //[[self.pickerTables.subviews objectAtIndex:2] setHidden:YES];
}

- (void)setupView {
    self.pickerTables.delegate = self;
    self.pickerTables.dataSource = self;
    self.navigationController.navigationBar.topItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"backLabel", nil)
                                     style:UIBarButtonItemStylePlain
                                    target:nil action:nil];
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
    UITapGestureRecognizer *generalGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.profileCommerceImage addGestureRecognizer:imageGesture];
    [self.uploadLabel addGestureRecognizer:labelGesture];
    [self.view addGestureRecognizer:generalGesture];
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
    if(![self validateImage]) {
        return;
    }
    SignInBankAccountViewController *viewController = (SignInBankAccountViewController *)
    [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInBankAccountViewController"];
    self.user.userType = [self.tablesQuantity.text integerValue] > 0 ? RestaurantNavigation : CommerceNavigation;
    viewController.user = self.user;
    viewController.commerceLogo = self.imageSelected;
    viewController.tables = self.tables;
    [self.navigationController pushViewController:viewController animated:true];
        
}


- (void)hideKeyBoard {
    [self.view endEditing:YES];
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

#pragma mark - validate data 
- (BOOL)validateImage {
    if(self.imageSelected == nil) {
        [self displayAlertWithMessage:NSLocalizedString(@"imageRequiredMessage", nil)];
        return  NO;
    }
    return YES;
}

- (void)displayAlertWithMessage:(NSString *)message {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:NSLocalizedString(@"errorTitle", nil)
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - picker delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 101;
}

// The data to return for the row and component (column) that's being passed in
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return row == 0 ? NSLocalizedString(@"tablesQuantityPlaceholder", nil) :
    [NSString stringWithFormat:@"%ld", (long)row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    self.tables = row;
}


@end
