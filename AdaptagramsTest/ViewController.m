//
//  ViewController.m
//  AdaptagramsTest
//
//  Created by Tang Tianyong on 13-8-20.
//  Copyright (c) 2013年 Tang Tianyong. All rights reserved.
//

#import "ViewController.h"



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

vector<vpsc::Rectangle*> rs;
vector<Edge> es;
RectangularCluster rc, rd;
unsigned iteration=0;

NSString *test1(void) {
//    RootCluster root;
    
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
    
	const unsigned c[]={0,4}, d[]={1,2,3};
	unsigned nc=sizeof(c)/sizeof(unsigned), nd=sizeof(d)/sizeof(unsigned);
	CheckProgress test(0.0001,100);
//	ConstrainedMajorizationLayout alg(rs,es,&root,30,NULL,test);
    
    ConstrainedFDLayout alg(rs, es, 50, true);
    
//    alg.setScaling(true);
	rc.nodes.resize(nc);
	copy(c,c+nc,rc.nodes.begin());
	rd.nodes.resize(nd);
	copy(d,d+nd,rd.nodes.begin());
//	root.clusters.push_back(&rc);
//	root.clusters.push_back(&rd);
	alg.makeFeasible();
//	alg.setAvoidOverlaps();
	alg.run();
    
//    OutputFile of(rs,es,&root,"containment.svg",false,true);
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    path = [path stringByAppendingPathComponent:@"libcola-debug"];
    
    std::string cppPath = [path cStringUsingEncoding:NSUTF8StringEncoding];
    
    cout << cppPath << endl;
    
//    alg.outputInstanceToSVG(cppPath);
    
    colaext::Render render(rs, es, true);
    
    std::string svgText = render.svgText();
    
    cout << svgText << endl;
    
//    of.generate();
	for(unsigned i=0;i<V;i++) {
		delete rs[i];
	}
    
    return [NSString stringWithCString:svgText.c_str()
                              encoding:[NSString defaultCStringEncoding]];
    
}


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self testAdaptagrams];
}

- (void)testAdaptagrams {
    
    NSString *svgText = test1();
    NSData *svgData = [svgText dataUsingEncoding:NSUTF8StringEncoding];
    SVGKSource *source = [SVGKSource sourceFromData:svgData];
    SVGKImage *svgImage = [SVGKImage imageWithSource:source];
    
    
    SVGKImageView *svgGraph = [[SVGKFastImageView alloc] initWithSVGKImage:svgImage];
    
    [self.view addSubview:svgGraph];
    
//
//    [self.view addSubview:svgGraph];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
