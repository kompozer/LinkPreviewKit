# LinkPreviewKit

[![Build Status](https://travis-ci.org/kompozer/LinkPreviewKit.svg?branch=master)](https://travis-ci.org/kompozer/LinkPreviewKit)
[![Version](https://img.shields.io/cocoapods/v/LinkPreviewKit.svg?style=flat)](http://cocoapods.org/pods/LinkPreviewKit)
[![License](https://img.shields.io/cocoapods/l/LinkPreviewKit.svg?style=flat)](http://cocoapods.org/pods/LinkPreviewKit)
[![Platform](https://img.shields.io/cocoapods/p/LinkPreviewKit.svg?style=flat)](http://cocoapods.org/pods/LinkPreviewKit)


µLibrary to fetch the social media meta tag information from a website URL. 

Supports Meta Tags for Standard Template (*title* and *description*), TwitterCard (*twitter:*) and OpenGraph (*og:*). 

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```objc

#import "LKLinkPreviewKit.h"

[LKLinkPreviewReader linkPreviewFromURL:URL completionHandler:^(NSArray *previews, NSError *error) {
    if (previews.count > 0  && ! error) {
        for (LKLinkPreview *preview in previews) {
            NSLog(@"title: %@", preview.title);
            NSLog(@"type: %@", preview.type);
            NSLog(@"URL: %@", preview.URL);
            NSLog(@"imageURL: %@", preview.imageURL);
            NSLog(@"linkDescription: %@", preview.linkDescription);
        }
    }
}];

```

## Requirements

## Installation

LinkPreviewKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LinkPreviewKit"
```

## Author

Andreas Kompanez, [@kompozer](https://twitter.com/kompozer)

## License

LinkPreviewKit is available under the MIT license. See the LICENSE file for more info.
