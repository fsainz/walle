$(document).ready(function(){
    var r = Raphael("holder");
    r.g.txtattr.font = "12px 'Fontin Sans', Fontin-Sans, sans-serif";
                
    var x = [], y = [], y2 = [], y3 = [];
    for (var i = 0; i < 1e3; i++) {
        x[i] = i * 10;
        y[i] = (y[i - 1] || 0) + (Math.random() * 7) - 3;
        y2[i] = (y2[i - 1] || 150) + (Math.random() * 7) - 3.5;
        y3[i] = (y3[i - 1] || 300) + (Math.random() * 7) - 4;
    }
 
 
    r.g.text(160, 10, "Simple Line Chart (1000 points)");
    r.g.linechart(20, 20, 800, 280, data[0], data[1],{
        axis: "0 0 1 1",
        "colors": ["#444","#444","#444","#444"]
    });
    r.g.linechart(20, 20, 800, 280, data2[0], data2[1],{
        "colors": ["#07F","#07F","#07F","#07F"]
    });
    
    
    //    var r = Raphael(10, 50, 640, 480);
    // Creates pie chart at with center at 320, 200,
    // radius 100 and data: [55, 20, 13, 32, 5, 1, 2]
//    r.g.piechart(620, 120, 100, [55, 20, 13, 32, 5, 1, 2]);
    
    
//    
//    
//    r.g.text(480, 10, "shade = true (10,000 points)");
//    r.g.linechart(330, 10, 300, 220, x, [y.slice(0, 1e4), y2.slice(0, 1e4), y3.slice(0, 1e4)], {
//        shade: true
//    });
//    
//    
//    
//    
//    
//    
//    
//    r.g.text(160, 250, "shade = true & nostroke = true (1,000,000 points)");
//    r.g.linechart(10, 250, 300, 220, x, [y, y2, y3], {
//        nostroke: true, 
//        shade: true
//    });
//    
//    
//    
//    
//    
//    
//   
//    r.g.text(480, 250, "Symbols, axis and hover effect"); 
//    var lines = r.g.linechart(330, 50, 300, 220, [[1, 2, 3, 4, 5, 6, 7],[3.5, 4.5, 5.5, 6.5, 7, 8]], [[12, 32, 23, 15, 17, 27, 22], [10, 20, 30, 25, 15, 28]], {
//        nostroke: false, 
//        axis: "0 0 1 1", 
//        symbol: "o", 
//        smooth: true
//    }).hoverColumn(function () {
//        this.tags = r.set();
//        for (var i = 0, ii = this.y.length; i < ii; i++) {
//            this.tags.push(r.g.tag(this.x, this.y[i], this.values[i], 160, 10).insertBefore(this).attr([{
//                fill: "#fff"
//            }, {
//                fill: this.symbols[i].attr("fill")
//                }]));
//        }
//    }, function () {
//        this.tags && this.tags.remove();
//    });
//    lines.symbols.attr({
//        r: 3
//    });
// lines.lines[0].animate({"stroke-width": 6}, 1000);
// lines.symbols[0].attr({stroke: "#fff"});
// lines.symbols[0][1].animate({fill: "#f00"}, 1000);
});
