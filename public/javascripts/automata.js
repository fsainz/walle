$(document).ready(function(){

    var r = Raphael("graph1");
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
    r.g.barchart(left_padding, 0, 1000/84 * histogram.length, 160, [histogram], 0, {
        type: "sharp"
    }).hover(fin, fout);
    var r_2 = Raphael("graph1_2");
    r_2.g.barchart(left_padding, 0, 1000/84 * ret_histogram.length, 160, [ret_histogram], 0, {
        type: "sharp"
    }).hover(fin, fout);
        
        
        
      
      
      
    var r2 = Raphael("graph2");
    r2.g.barchart(0, 0, 1000/84 * histogram2.length, 160, [histogram2], 0, {
        type: "sharp"
    }).hover(fin, fout);
    var r2_2 = Raphael("graph2_2");
    r2_2.g.barchart(0, 0, 1000/84 * ret_histogram2.length, 160, [ret_histogram2], 0, {
        type: "sharp"
    }).hover(fin, fout);
        
        
        

    var retentions = Raphael("retentions");
    retentions.g.txtattr.font = "12px 'Fontin Sans', Fontin-Sans, sans-serif";
    retentions.g.text(160, 10, "Retention evolution");
    retentions.g.linechart(20, 20, 800, 280, [x2, x1], [y2, y1],{
        axis: "0 0 1 1",
        "colors": ["#446","#F00","#0F0","#00F"]
    });
    
    
    var healthy_cards = Raphael("healthy_cards");
    healthy_cards.g.txtattr.font = "12px 'Fontin Sans', Fontin-Sans, sans-serif";
    healthy_cards.g.text(160, 10, "Number of healthy cards (retention > 50%) by day");
    healthy_cards.g.linechart(20, 20, 800, 280, [x4, x3], [y4, y3],{
        axis: "0 0 1 1",
        "colors": ["#446","#F00","#0F0","#00F"]
    });
    
    var retention_status1 = Raphael("retention_status_for_random");
    retention_status1.g.txtattr.font = "12px 'Fontin Sans', Fontin-Sans, sans-serif";
    retention_status1.g.text(160, 10, "By week, number of cards with retention between 0-50%, 50-70% and 70-100%");
    retention_status1.g.barchart(20, 20, 800, 280, x5,{
        axis: "0 0 1 1",
        stacked: true,
        "colors": ["#FDD","#A99","#644","#00F"]
    });
    
    var retention_status2 = Raphael("retention_status_for_walle");
    retention_status2.g.txtattr.font = "12px 'Fontin Sans', Fontin-Sans, sans-serif";
    retention_status2.g.text(160, 10, "By week, number of cards with retention between 0-50%, 50-70% and 70-100%");
    retention_status2.g.barchart(20, 20, 800, 280, x6,{
        axis: "0 0 1 1",
        stacked: true,
        "colors": ["#DDF","#99A","#446","#00F"]
    });
    
    
    
    
    
//    retentions.g.linechart(20, 20, 800, 280, x1, y1,{
//        axis: "1 1 0 0",
//        "colors": ["#07F","#07F","#07F","#07F"]
//    });
        
        
        
        
        
        
        
        
        
        
        
        
        
        
               
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