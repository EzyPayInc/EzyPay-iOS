//
//  ScannerViewController.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 1/3/17.
//  Copyright © 2017 EzyPay Inc. All rights reserved.
//

#import "BarcodeScannerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface BarcodeScannerViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (weak, nonatomic) IBOutlet UIView *scannerView;

@end

@implementation BarcodeScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupScanner];
    self.scannerView.layer.borderWidth = 5;
    self.scannerView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.scannerView.layer.cornerRadius = 30;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupScanner {
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        self.captureSession = [[AVCaptureSession alloc] init];
        [self.captureSession addInput:input];
        AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [self.captureSession addOutput:captureMetadataOutput];
        
        dispatch_queue_t dispatchQueue;
        dispatchQueue = dispatch_queue_create("myQueue", NULL);
        [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
        [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
        
        self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [self.videoPreviewLayer setFrame:self.view.layer.bounds];
        [self.view.layer addSublayer:self.videoPreviewLayer];
        
        [_captureSession startRunning];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadaObj = [metadataObjects objectAtIndex:0];
        if ([[metadaObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSLog(@"%@ ", [metadaObj stringValue]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopBarcodeScanner];
                [self.navigationController popViewControllerAnimated:true];
                [self.delegate barcodeScannerDidScanBarcode:[metadaObj stringValue]];
            });
        }
    }
}

- (void)stopBarcodeScanner {
    [self.captureSession stopRunning];
    self.captureSession = nil;
}

@end
