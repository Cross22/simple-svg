//
//  AppDelegate.m
//  svg-test
//
//  Created by Marco Grubert on 6/21/15.
//  Copyright (c) 2015 Marco Grubert. All rights reserved.
//

#import "AppDelegate.h"
#include <string>

#define FILE_NAME "my_svg.svg"
extern void makeSvgDocument(const std::string &fileName= "my_svg.svg");

@interface AppDelegate () <NSWindowDelegate>

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    makeSvgDocument(FILE_NAME);
    NSURL *url= [NSURL fileURLWithPathComponents:@[
                                       [NSFileManager defaultManager].currentDirectoryPath, @FILE_NAME]];
    [self.webView.mainFrame loadRequest:[NSURLRequest requestWithURL:url]];

    self.window.delegate= self;
    
    [self sizeToFit];
}

- (void) sizeToFit {
    
    static float currentScale= 1.0f;
    NSView* docView=self.webView.mainFrame.frameView.documentView;
    docView.frame= docView.superview.frame;
    float scale= fmin(docView.frame.size.width / 100.0f,
                      docView.frame.size.height / 100.0f);
    scale /= currentScale;
    currentScale*= scale;
    // This is a very strange function it's a RELATIVE scale factor relying on the
    // previous scale factor which cannot be queried- that's why we store it in
    // currentScale and undo (divide) the previous transform.
    [docView.superview scaleUnitSquareToSize:NSMakeSize(scale, scale)];
}

-(void)windowDidResize:(NSNotification *)notification
{
    [self sizeToFit];
}
@end
