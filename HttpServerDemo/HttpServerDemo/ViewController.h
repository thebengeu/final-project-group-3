//
//  ViewController.h
//  HttpServerDemo
//
//  Created by k on 12/3/13.
//  Copyright (c) 2013 k. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HTTPServer.h"

@interface ViewController : UIViewController

@property HTTPServer *httpServer;

@property UITextView *text;

@end
