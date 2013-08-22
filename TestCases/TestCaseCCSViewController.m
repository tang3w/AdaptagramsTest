// TestCaseCCSViewController.m
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

#import "TestCaseCCSViewController.h"

#include <iostream>

#include <vector>
#include <algorithm>
#include <float.h>
#include <libcola/cola.h>
#include <libcola/output_svg.h>

#include "librender.h"

#import "SVGKFastImageView.h"

inline double getRand(double range) {
	return range*rand()/RAND_MAX;
}

using namespace std;
using namespace cola;

@interface TestCaseCCSViewController ()

@end

@implementation TestCaseCCSViewController

- (void)testCase {
    
    const unsigned V = 4;
	typedef pair < unsigned, unsigned >Edge;
	Edge edge_array[] = { Edge(0, 1), Edge(1, 2), Edge(2, 3), Edge(1, 3) };
	unsigned E = sizeof(edge_array) / sizeof(Edge);
	vector<Edge> es(edge_array,edge_array+E);
	double width=100;
	double height=100;
	vector<vpsc::Rectangle*> rs;
	for(unsigned i=0;i<V;i++) {
		double x=getRand(width), y=getRand(height);
		rs.push_back(new vpsc::Rectangle(x,x+5,y,y+5));
	}
	CompoundConstraints ccs;
	AlignmentConstraint ac(vpsc::XDIM);
	ccs.push_back(&ac);
	ac.addShape(0,0);
	ac.addShape(3,0);
	// apply steepest descent layout
	ConstrainedFDLayout alg2(rs,es,width/2, false);
	alg2.setConstraints(ccs);
	alg2.run();
    
	// reset rectangles to random positions
	for(unsigned i=0;i<V;i++) {
		double x=getRand(width), y=getRand(height);
		rs[i]->moveCentre(x,y);
	}
	// apply scaled majorization layout
	ConstrainedMajorizationLayout alg(rs,es,NULL,width/2);
	alg.setConstraints(&ccs);
	alg.setScaling(true);
	alg.run();
    
	cout<<rs[0]->getCentreX()<<","<<rs[3]->getCentreX()<<endl;
    
    colaext::Render render(rs, es, true);
    
    std::string svgCText = render.svgText();
    
    NSString *svgText = [NSString stringWithCString:svgCText.c_str() encoding:[NSString defaultCStringEncoding]];
    
    NSData *svgData = [svgText dataUsingEncoding:NSUTF8StringEncoding];
    SVGKSource *svgSource = [SVGKSource sourceFromData:svgData];
    SVGKImage *svgImage = [SVGKImage imageWithSource:svgSource];
    
    SVGKFastImageView *svgGraph = [[SVGKFastImageView alloc] initWithSVGKImage:svgImage];
    
    [self.view addSubview:svgGraph];
    
}

@end
