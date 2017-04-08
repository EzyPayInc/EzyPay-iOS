//
//  QRPaymentViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 3/13/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "QRPaymentViewController.h"
#import "UserManager.h"

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

- (NSString *)generateQRInformation
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self serializePayment] options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (NSDictionary *)serializePayment {
    NSMutableDictionary *paymentDictionary = [self serializeObject:self.payment];
    [paymentDictionary setObject:[self serializeObject:self.payment.commerce] forKey:@"Commerce"];
    [paymentDictionary setObject:[self serializeObject:self.payment.currency] forKey:@"Currency"];
    
    return paymentDictionary;
    
}

- (NSMutableDictionary *)serializeObject:(id)object {
    NSArray *keys = [[[object entity] attributesByName] allKeys];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (NSString *key in keys) {
        if([object valueForKey:key] && ![key isEqualToString:@"token"]) {
            [dictionary setObject:[object valueForKey:key] forKey:key];
        }
    }
    return dictionary;
}

@end
