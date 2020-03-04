#import "SaveImagePlugin.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

@interface SaveImagePlugin ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@end

@implementation SaveImagePlugin  {
    FlutterResult _result;
    NSDictionary *_arguments;
    UIImagePickerController *_imagePickerController;
    UIViewController *_viewController;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel =
    [FlutterMethodChannel methodChannelWithName:@"aissz.com/save_image"
                                binaryMessenger:[registrar messenger]];
    UIViewController *viewController =
    [UIApplication sharedApplication].delegate.window.rootViewController;
    SaveImagePlugin *instance =
    [[SaveImagePlugin alloc] initWithViewController:viewController];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
        _imagePickerController = [[UIImagePickerController alloc] init];
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (_result) {
        _result([FlutterError errorWithCode:@"multiple_request"
                                    message:@"Cancelled by a second request"
                                    details:nil]);
        _result = nil;
    }
    if ([@"saveImageToGallery" isEqualToString:call.method]) {
        _result = result;
        _arguments = call.arguments;
        FlutterStandardTypedData* fileData = [_arguments objectForKey:@"imageBytes"] ;
        UIImage *image=[UIImage imageWithData:fileData.data];
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted) {
        } else if (status == PHAuthorizationStatusDenied) { 
        } else if (status == PHAuthorizationStatusAuthorized) {
            [self saveImage:image];
        } else if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self saveImage:image];
                }
            }];
        }
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

-(void)saveImage:(UIImage *)image  {
    __block NSString* localId;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        localId = [[assetChangeRequest placeholderForCreatedAsset] localIdentifier];
    } completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            PHFetchResult* assetResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[localId] options:nil];
            PHAsset *asset = [assetResult firstObject];
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                self->_result([NSNumber numberWithBool:1]);
            }];
        } else {
           self->_result([NSNumber numberWithBool:0]);
        }
    }];
}

@end

