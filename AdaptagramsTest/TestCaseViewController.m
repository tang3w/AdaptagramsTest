// TestCaseViewController.m
//
// Copyright (c) 2013 Tang Tianyong
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
// KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
// AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

#import "TestCaseViewController.h"

#include "librender.h"

using namespace colaext;

SVGKFastImageView *toSVG(Rectangles const &rs, std::vector<Edge> const &es, const bool curvedEdges) {
    colaext::Render render(rs, es, curvedEdges);
    std::string svgCText = render.svgText();
    NSString *svgText = [NSString stringWithCString:svgCText.c_str() encoding:[NSString defaultCStringEncoding]];
    
    NSData *svgData = [svgText dataUsingEncoding:NSUTF8StringEncoding];
    SVGKSource *svgSource = [SVGKSource sourceFromData:svgData];
    SVGKImage *svgImage = [SVGKImage imageWithSource:svgSource];
    SVGKFastImageView *svgGraph = [[SVGKFastImageView alloc] initWithSVGKImage:svgImage];
    
    return svgGraph;
}

@implementation TestCaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect frame = self.view.bounds;
    
    frame.size.height -= 44.0f;
    
    self.view.frame = frame;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    frame = self.view.bounds;
    
    frame.size.height /= 2.0f;
    
    UIView *topview = [[UIView alloc] initWithFrame:frame];
    
    topview.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:topview];
    
    self.topView = topview;
    
    frame.origin.y = frame.size.height;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:frame];
    
    [self.view addSubview:bottomView];
    
    self.bottomView = bottomView;
    
    bottomView.backgroundColor = [UIColor grayColor];
    
    [self testCase];
}

- (void)testCase {
    // Stub
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
