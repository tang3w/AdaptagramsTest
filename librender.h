// librender.h
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

#ifndef __AdaptagramsTest__librender__
#define __AdaptagramsTest__librender__

#include "libcola/cola.h"

namespace colaext {
    
class Render {
public:
    std::vector<straightener::Route*> *routes;
    
    Render(std::vector<vpsc::Rectangle*> const &rs,
           std::vector<cola::Edge> const &es,
           const bool curvedEdges=false);
    std::string svgText();
private:
    std::vector<vpsc::Rectangle*> const &rs;
	std::vector<cola::Edge> const &es;
	bool curvedEdges;
    
    void svgDrawBoundary(std::stringstream &svgText,
                         cola::Cluster &c,
                         const double xmin,
                         const double ymin);
    
    void svgDrawEdges(std::stringstream &svgText,
                      std::vector<straightener::Route*> const & es,
                      double const xmin,
                      double const ymin);
    
    void svgDrawCurvedEdges(std::stringstream &svgText,
                            std::vector<cola::Edge> const & es,
                            const double xmin,
                            const double ymin);
};

}

#endif