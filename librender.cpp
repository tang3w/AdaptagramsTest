// librender.cpp
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

#include "librender.h"

using namespace std;
using namespace cola;

std::string randomColor() {
    std::stringstream color;
    
    color << arc4random() % 200 + 56;
    color << ",";
    color << arc4random() % 200 + 56;
    color << ",";
    color << arc4random() % 200 + 56;
    
    return color.str();
}

namespace colaext {
    
Render::Render(std::vector<vpsc::Rectangle*> const &rs,
               std::vector<cola::Edge> const &es,
               const bool curvedEdges)
: rs(rs), es(es), curvedEdges(curvedEdges), routes(NULL) {}

std::string Render::svgText() {
    std::stringstream svgText;
    
    svgText << "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>";
    svgText << "<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">";
    
    unsigned E=es.size();
    bool cleanupRoutes=false;
    if(routes==NULL) {
        cleanupRoutes=true;
        routes = new vector<straightener::Route*>(E);
        for(unsigned i=0;i<E;i++) {
            straightener::Route* r=new straightener::Route(2);
            r->xs[0]=rs[es[i].first]->getCentreX();
            r->ys[0]=rs[es[i].first]->getCentreY();
            r->xs[1]=rs[es[i].second]->getCentreX();
            r->ys[1]=rs[es[i].second]->getCentreY();
            (*routes)[i]=r;
        }
    }
    
    double width,height,r=2;
    r=rs[0]->width()/2;
    double xmin=DBL_MAX, ymin=xmin;
    double xmax=-DBL_MAX, ymax=xmax;
    for (unsigned i=0;i<rs.size();i++) {
        double x=rs[i]->getCentreX(), y=rs[i]->getCentreY();
        xmin=min(xmin,x);
        ymin=min(ymin,y);
        xmax=max(xmax,x);
        ymax=max(ymax,y);
    }
    xmax+=2*r;
    ymax+=2*r;
    xmin-=2*r;
    ymin-=2*r;
    width=xmax-xmin;
    height=ymax-ymin;
    
    svgText << "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\"";
    svgText << " width=\"" << width << "\"";
    svgText << " height=\"" << height << "\"";
    svgText << ">";
    
    if (curvedEdges) {
        svgDrawCurvedEdges(svgText, es, xmin, ymin);
    } else {
        svgDrawEdges(svgText, *routes, xmin, ymin);
    }
    
    for (unsigned i = 0; i < rs.size(); i++) {
        double x = rs[i]->getMinX() - xmin;
        double y = rs[i]->getMinY() - ymin;
        double width = rs[i]->width();
        double height = rs[i]->height();
        double textX = x + width / 2.0 - 4;
        double textY = y + height / 2.0 + 7.5;
        
        std::stringstream g;
        std::stringstream rect;
        std::stringstream text;
        
        rect << "<rect";
        rect << " x=\"" << x << "\"";
        rect << " y=\"" << y << "\"";
        rect << " width=\"" << width << "\"";
        rect << " height=\"" << height << "\"";
        rect << " style=\"fill:rgb(" << randomColor() << ");\"";
        rect << "/>";
        
        text << "<text";
        text << " x=\"" << textX << "\"";
        text << " y=\"" << textY << "\"";
        text << " style=\"" << "font-size:12;" << "\"";
        text << ">";
        text << i + 1;
        text << "</text>";
        
        g << "<g>" << rect.str() << text.str() << "</g>";
        
        svgText << g.str();
    }
    
    svgText << "</svg>";
    
    return svgText.str();
}

void Render::svgDrawBoundary(std::stringstream &svgText,
                             cola::Cluster &c,
                             const double xmin,
                             const double ymin)
{
    c.computeBoundary(rs);
    
    std::stringstream points;
    
    points << c.hullX[0] - xmin << "," << c.hullY[0] - ymin;
    
    for(unsigned i = 1; i < c.hullX.size(); i++) {
        points << " " << c.hullX[i] - xmin << "," << c.hullY[i] - ymin;
    }
    
    svgText << "<polygon points=\"" << points << "\"";
    svgText << " style=\"fill:lime; stroke:purple; stroke-width:1\"";
    svgText << "/>";
}

void Render::svgDrawEdges(std::stringstream &svgText,
                          std::vector<straightener::Route*> const & es,
                          double const xmin,
                          double const ymin)
{
    for (unsigned i = 0; i < es.size(); i++) {
        const straightener::Route* r = es[i];
        std::stringstream points;
        
        points << r->xs[0] - xmin << "," << r->ys[0] - ymin;
        
        for (unsigned j = 1; j < r->n; j++) {
            points << " " << r->xs[j] - xmin << "," << r->ys[j] - ymin;
        }
        
        svgText << "<polyline points=\"" << points.str() << "\"";
        svgText << " style=\"fill:none; stroke:rgb(255,234,179); stroke-width:3;\"";
        svgText << "/>";
    }
}

namespace bundles {

struct CEdge {
    unsigned startID, endID;
    double x0,y0,x1,y1,x2,y2,x3,y3;
};

struct CBundle;

struct CNode {
    double x,y;
    vector<CEdge*> edges;
    list<CBundle*> bundles;
};

double vangle(double ax,double ay, double bx, double by) {
    double ab=ax*bx+ay*by;
    double len=sqrt(ax*ax+ay*ay)*sqrt(bx*bx+by*by);
    double angle=acos(ab/len);
    return angle;
}

struct CBundle {
    unsigned w;
    double x0, y0;
    double sx,sy;
    vector<CEdge*> edges;
    CBundle(CNode const &u) : w(u.edges.size()), x0(u.x), y0(u.y), sx(w*u.x), sy(w*u.y) { }
    void addEdge(CEdge *e) {
        if(x0==e->x0 && y0==e->y0) {
            sx+=e->x3; sy+=e->y3;
        } else {
            sx+=e->x0; sy+=e->y0;
        }
        edges.push_back(e);
    }
    double x1() const {
        return sx/(w+edges.size());
    }
    double y1() const {
        return sy/(w+edges.size());
    }
    double angle(CBundle* const &b) const {
        double ax=x1()-x0;
        double ay=y1()-y0;
        double bx=b->x1()-b->x0;
        double by=b->y1()-b->y0;
        return vangle(ax,ay,bx,by);
    }
    double yangle() const {
        double x=x1()-x0;
        double y=y1()-y0;
        double o=x<0?1:-1;
        return vangle(0,1,x,y)*o+M_PI;
    }
    void merge(CBundle* b) {
        for(unsigned i=0;i<b->edges.size();i++) {
            addEdge(b->edges[i]);
        }
    }
    void dump() {
        printf("Bundle: ");
        for(unsigned i=0;i<edges.size();i++) {
            printf("(%d,%d) ",edges[i]->startID,edges[i]->endID);
        }
    }
};

struct clockwise {
    bool operator() (CBundle* const &a, CBundle* const &b) {
        return a->yangle()<b->yangle();
    }
};

}

void Render::svgDrawCurvedEdges(std::stringstream &svgText,
                                std::vector<cola::Edge> const & es,
                                const double xmin,
                                const double ymin)
{
    using namespace bundles;
    vector<CNode> nodes(rs.size());
    vector<CEdge> edges(es.size());
    for (unsigned i=0;i<es.size();i++) {
        CEdge *e=&edges[i];
        unsigned start=es[i].first;
        unsigned end=es[i].second;
        e->startID=start;
        e->endID=end;
        nodes[start].x=rs[start]->getCentreX()-xmin;
        nodes[start].y=rs[start]->getCentreY()-ymin;
        nodes[end].x=rs[end]->getCentreX()-xmin;
        nodes[end].y=rs[end]->getCentreY()-ymin;
        e->x0=nodes[start].x;
        e->x1=nodes[start].x;
        e->x2=nodes[end].x;
        e->x3=nodes[end].x;
        e->y0=nodes[start].y;
        e->y1=nodes[start].y;
        e->y2=nodes[end].y;
        e->y3=nodes[end].y;
        nodes[end].edges.push_back(e);
        nodes[start].edges.push_back(e);
    }
    
    for (unsigned i=0;i<nodes.size();i++) {
        CNode u=nodes[i];
        if(u.edges.size()<2) continue;
        for (unsigned j=0;j<u.edges.size();j++) {
            CBundle* b=new CBundle(u);
            b->addEdge(u.edges[j]);
            u.bundles.push_back(b);
        }
        u.bundles.sort(clockwise());
        while(true) {
            double minAngle=DBL_MAX;
            list<CBundle*>::iterator mini,minj,i,j;
            for(i=u.bundles.begin();i!=u.bundles.end();i++) {
                j=i;
                if(++j==u.bundles.end()) {
                    j=u.bundles.begin();
                }
                CBundle* a=*i;
                CBundle* b=*j;
                double angle=b->yangle()-a->yangle();
                if(angle<0) angle+=2*M_PI;
                if(angle<minAngle) {
                    minAngle=angle;
                    mini=i;
                    minj=j;
                }
            }
            if(minAngle>cos(M_PI/8.)) break;
            CBundle* a=*mini;
            CBundle* b=*minj;
            b->merge(a);
            u.bundles.erase(mini);
            if(u.bundles.size() < 2) break;
        }
        for(list<CBundle*>::iterator i=u.bundles.begin();i!=u.bundles.end();i++) {
            CBundle* b=*i;
            for(unsigned i=0;i<b->edges.size();i++) {
                CEdge* e=b->edges[i];
                if(e->x0==u.x&&e->y0==u.y) {
                    e->x1=b->x1();
                    e->y1=b->y1();
                } else {
                    e->x2=b->x1();
                    e->y2=b->y1();
                }
            }
        }
    }
    
    for (unsigned i = 0; i < edges.size(); i++) {
        CEdge &e=edges[i];
        
        std::stringstream M;
        std::stringstream C;
        
        M << e.x0 << "," << e.y0;
        C << e.x1 << "," << e.y1 << " " << e.x2 << "," << e.y2 << " " << e.x3 << "," << e.y3;
        
        svgText << "<path d=\"M" << M.str() << " C" << C.str() << "\"";
        svgText << " style=\"fill:none; stroke:stroke:rgb(255,234,179); stroke-width:3;\"";
        svgText << "/>";
    }
}

}
