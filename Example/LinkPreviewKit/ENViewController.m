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
@property (weak, nonatomic) IBOutlet UITextView *previewTextView;

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
    
    [LKLinkPreviewReader linkPreviewFromURL:URL completionHandler:^(NSArray *previews, NSError *error) {
        if (previews.count > 0  && ! error) {
            NSMutableString *text = [NSMutableString new];
            for (LKLinkPreview *preview in previews) {
                [text appendFormat:@"%@\n", [preview description]];
            }
            self.previewTextView.text = text;
        }
        else {
            self.previewTextView.text = @"Error";
        }
    }];
}

@end
