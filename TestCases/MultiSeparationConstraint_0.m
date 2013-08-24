// MultiSeparationConstraint_0.m
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

#import "MultiSeparationConstraint_0.h"

@implementation MultiSeparationConstraint_0

- (void)testCase {
    Rectangles rs;
    rs.push_back(new Rectangle(10, 60, 10, 60));
    rs.push_back(new Rectangle(50, 100, 30, 80));
    rs.push_back(new Rectangle(80, 130, 60, 110));
    rs.push_back(new Rectangle(20, 70, 50, 100));
    
    std::vector<Edge> es;
    
    [self addDisplayView:toSVG(rs, es, true)];
    
    // Alignmenet
    ConstrainedFDLayout alg(rs, es, 60, true);
    
    CompoundConstraints ccs;
    
    AlignmentConstraint *conY = new AlignmentConstraint(vpsc::YDIM);
    conY->addShape(0, 0);
    conY->addShape(1, 50);
    
    AlignmentConstraint *conY1 = new AlignmentConstraint(vpsc::YDIM, 50);
    conY1->addShape(2, 0);
    conY1->addShape(3, 50);
    
    MultiSeparationConstraint *con = new MultiSeparationConstraint(vpsc::YDIM, 120);
    con->addAlignmentPair(conY, conY1);
    
    ccs.push_back(conY);
    ccs.push_back(conY1);
    ccs.push_back(con);
    
    alg.setConstraints(ccs);
    alg.run();
    
    [self addDisplayView:toSVG(rs, es, true)];
}

@end
