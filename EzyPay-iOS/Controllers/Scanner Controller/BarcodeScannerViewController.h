//
//  ScannerViewController.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/3/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BarcodeScanner;
@protocol BarcodeScannerDelegate <NSObject>
- (void)barcodeScannerDidScanBarcode:(NSString *)barcodeString;
@end

@interface BarcodeScannerViewController : UIViewController

@property (nonatomic, assign) id <BarcodeScannerDelegate> delegate;

@end
