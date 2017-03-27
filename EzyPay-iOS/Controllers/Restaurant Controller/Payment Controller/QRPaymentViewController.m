//
//  QRPaymentViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/13/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "QRPaymentViewController.h"
#import "User+CoreDataClass.h"

@interface QRPaymentViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;

@end

@implementation QRPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"QR Code";
    [self generateQRCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)generateQRCode
{
    NSString *qrString = [self generateQRInformation];
    NSData *stringData = [qrString dataUsingEncoding: NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    float scaleX = self.qrImageView.frame.size.width / qrImage.extent.size.width;
    float scaleY = self.qrImageView.frame.size.height / qrImage.extent.size.height;
    
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    
    self.qrImageView.image = [UIImage imageWithCIImage:qrImage
                                                 scale:[UIScreen mainScreen].scale
                                           orientation:UIImageOrientationUp];
}

- (NSString *)generateQRInformation {
    NSString *qRInformation = [NSString stringWithFormat:@"{\"commerceId\": %lld, \"tableNumber\": %lld, \"commerceName\": %@, \"cost\": %f }", self.table.restaurant.id, self.table.tableId, self.table.restaurant.name,self.cost];
    return qRInformation;
}

@end
