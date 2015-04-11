//
//  ENViewController.m
//  LinkPreviewKit
//
//  Created by Andreas Kompanez on 04/11/2015.
//  Copyright (c) 2014 Andreas Kompanez. All rights reserved.
//

#import "ENViewController.h"

#import "LKLinkPreviewKit.h"

@interface ENViewController ()

@property (weak, nonatomic) IBOutlet UITextField *urlTextField;

@end

@implementation ENViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)previewLinkTapped:(id)sender
{
    NSString *content = self.urlTextField.text;
    if (0 == content.length) {
        return;
    }
    NSURL *URL = [NSURL URLWithString:content];
    if (! URL) {
        return;
    }
    
    [LKLinkPreviewKit linkPreviewFromURL:URL completionHandler:^(LKLinkPreview *preview, NSError *error) {
        if (preview && ! error) {
            NSLog(@"%s HEY! %@", __PRETTY_FUNCTION__, preview);
            
        }
        else {
            NSLog(@"%s Erorr!", __PRETTY_FUNCTION__);
        }
    }];
}

@end
