// SeparationConstraint_0.m
//
// Copyright (c) 2013年 Tang Tianyong
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

#import "SeparationConstraint_0.h"

@implementation SeparationConstraint_0

- (void)testCase {
    Rectangles rs;
    rs.push_back(new Rectangle(10, 60, 10, 60));
    rs.push_back(new Rectangle(50, 100, 30, 80));
    rs.push_back(new Rectangle(80, 130, 60, 110));
    rs.push_back(new Rectangle(20, 70, 50, 100));
    
    std::vector<Edge> es;
    
    [self addDisplayView:toSVG(rs, es, true)];
    
    
    // Alignmenet
    
    es.push_back(Edge(0, 1));
    es.push_back(Edge(1, 2));
    es.push_back(Edge(0, 3));
    es.push_back(Edge(2, 3));
    
    ConstrainedFDLayout alg(rs, es, 80, true);
    
    CompoundConstraints ccs;
    
    SeparationConstraint *conX0 = new SeparationConstraint(vpsc::XDIM, 0, 1, 110, true);
    SeparationConstraint *conX1 = new SeparationConstraint(vpsc::XDIM, 3, 1, 60, true);
    SeparationConstraint *conX2 = new SeparationConstraint(vpsc::XDIM, 1, 2, 70, true);
    
    SeparationConstraint *conY0 = new SeparationConstraint(vpsc::YDIM, 0, 3, 50, true);
    SeparationConstraint *conY1 = new SeparationConstraint(vpsc::YDIM, 1, 3, 50, true);
    SeparationConstraint *conY2 = new SeparationConstraint(vpsc::YDIM, 1, 2, 50, true);
    
    ccs.push_back(conX0);
    ccs.push_back(conX1);
    ccs.push_back(conX2);
    ccs.push_back(conY0);
    ccs.push_back(conY1);
    ccs.push_back(conY2);
    
    alg.run();
    
    [self addDisplayView:toSVG(rs, es, true)];
    
    alg.setConstraints(ccs);
    alg.run();
    
    [self addDisplayView:toSVG(rs, es, true)];
    
    
    
    
    CompoundConstraints ccs1;
    
    conX0 = new SeparationConstraint(vpsc::XDIM, 0, 1, 110, false);
    conX1 = new SeparationConstraint(vpsc::XDIM, 3, 1, 60, false);
    conX2 = new SeparationConstraint(vpsc::XDIM, 1, 2, 70, false);
    
    conY0 = new SeparationConstraint(vpsc::YDIM, 0, 3, 50, false);
    conY1 = new SeparationConstraint(vpsc::YDIM, 1, 3, 50, false);
    conY2 = new SeparationConstraint(vpsc::YDIM, 1, 2, 50, false);
    
    ccs1.push_back(conX0);
    ccs1.push_back(conX1);
    ccs1.push_back(conX2);
    ccs1.push_back(conY0);
    ccs1.push_back(conY1);
    ccs1.push_back(conY2);
    
    alg.setConstraints(ccs1);
    
    alg.run();
    
    [self addDisplayView:toSVG(rs, es, true)];
    
}

@end
