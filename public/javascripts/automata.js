$(document).ready(function(){

    var r = Raphael("graph");
    r.g.txtattr.font = "12px 'Fontin Sans', Fontin-Sans, sans-serif";

    var left_padding = 0;
    fin = function () {
        this.flag = r.g.popup(this.bar.x, this.bar.y, this.bar.value || "0").insertBefore(this);
    },
    fout = function () {
        this.flag.animate({
            opacity: 0
        }, 300, function () {
            this.remove();
        });
    }        
    r.g.barchart(left_padding, 10, 1000/84 * histogram.length, 320, [histogram], 0, {
        type: "sharp"
    }).hover(fin, fout);
        
        
        
      
      
      
    var r2 = Raphael("graph2");
    r2.g.txtattr.font = "12px 'Fontin Sans', Fontin-Sans, sans-serif";
    r2.g.barchart(0, 10, 1000/84 * histogram2.length, 320, [histogram2], 0, {
        type: "sharp"
    }).hover(fin, fout);
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
               
//    
//    
//    r.g.text(160, 10, "Week 1");
//    r.g.barchart(130, 10, 100, 120, [[55, 20, 13, 32, 5, 1, 2, 10]], 0, {
//        type: "sharp"
//    });


//    
//    
//    r.g.text(480, 10, "Multiline Series Chart");
//    r.g.text(160, 250, "Multiple Series Stacked Chart");
//    r.g.text(480, 250, "Multiline Series Stacked Vertical Chart. Type “round”");
//    
//    var data1 = [[55, 20, 13, 32, 5, 1, 2, 10], [10, 2, 1, 5, 32, 13, 20, 55], [12, 20, 30]],
//        data2 = [[55, 20, 13, 32, 5, 1, 2, 10], [10, 2, 1, 5, 32, 13, 20, 55], [12, 20, 30]],
//        data3 = [[55, 20, 13, 32, 5, 1, 2, 10], [10, 2, 1, 5, 32, 13, 20, 55], [12, 20, 30]];
//        
//    r.g.barchart(330, 10, 300, 220, data1);
//    r.g.barchart(10, 250, 300, 220, data2, {
//        stacked: true
//    });
//    r.g.barchart(330, 250, 300, 220, data3, {
//        stacked: true, 
//        type: "round"
//    });
//    
});