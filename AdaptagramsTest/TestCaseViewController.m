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

@implementation TestCaseViewController {
    __weak UITableView *_tableView;
    NSMutableArray *_displayViews;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _displayViews = [NSMutableArray array];
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
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    _tableView = tableView;
    
    [self testCase];
}

- (void)testCase {
    // Stub
}

- (void)addDisplayView:(UIView *)view {
    [_displayViews addObject:view];
    NSLog(@"%@", _tableView);
    [_tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _displayViews.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_displayViews[indexPath.row] frame].size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [cell.contentView addSubview:_displayViews[indexPath.row]];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
