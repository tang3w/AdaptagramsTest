// TestCaseConstrainedFDLayout.m
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

#import "TestCaseConstrainedFDLayout.h"

#include <iostream>

#include <map>
#include <vector>
#include <algorithm>
#include <float.h>
#include <iomanip>
#include "libcola/cola.h"
#include "libcola/output_svg.h"
#include "graphlayouttest.h"

#include "librender.h"

#import "SVGKFastImageView.h"

using namespace cola;
using namespace std;

@implementation TestCaseConstrainedFDLayout

- (void)testCase {
    
    vector<vpsc::Rectangle*> rs;
    vector<Edge> es;
    RectangularCluster rc, rd;
    
    const unsigned V = 6;
	typedef pair < unsigned, unsigned >Edge;
	Edge edge_array[] = { Edge(0, 1), Edge(1, 2), Edge(1, 3), Edge(1, 4), Edge(2, 4), Edge(5, 4) };
	const std::size_t E = sizeof(edge_array) / sizeof(Edge);
	es.resize(E);
	copy(edge_array,edge_array+E,es.begin());
    
	double width=100;
	double height=100;
    
	for(unsigned i=0;i<V;i++) {
		double x=getRand(width), y=getRand(height);
		rs.push_back(new vpsc::Rectangle(x,x+20,y,y+15));
	}
    
    ConstrainedFDLayout alg(rs, es, 60, true);
    
	alg.run();
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    path = [path stringByAppendingPathComponent:@"libcola-debug"];
    
    std::string cppPath = [path cStringUsingEncoding:NSUTF8StringEncoding];
    
    colaext::Render render(rs, es, true);
    
    std::string svgCText = render.svgText();
    
	for(unsigned i=0;i<V;i++) {
		delete rs[i];
	}
    
    NSString *svgText = [NSString stringWithCString:svgCText.c_str()
                                           encoding:[NSString defaultCStringEncoding]];
    
    NSData *svgData = [svgText dataUsingEncoding:NSUTF8StringEncoding];
    
    SVGKSource *svgSource = [SVGKSource sourceFromData:svgData];
    SVGKImage *svgImage = [SVGKImage imageWithSource:svgSource];
    
    SVGKFastImageView *svgGraph = [[SVGKFastImageView alloc] initWithSVGKImage:svgImage];
    
    [self.view addSubview:svgGraph];
}

@end
