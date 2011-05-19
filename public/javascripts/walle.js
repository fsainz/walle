var data = pv.range(0, 10, .1).map(function(x) {
    return {x: x, y: Math.sin(x) + Math.random() * .5 + 2};
  });
var data2 = pv.range(0, 10, .1).map(function(x) {
    return {x: x, y: Math.cos(x) + Math.random() * .5 + 2};
  });
var data3 = pv.range(0, 10, .1).map(function(x) {
    return {x: x, y: Math.sin(x) + Math.random() * .5 + 2};
  });
  
  var datas = [data, data2, data3];
  
/* Sizing and scales. */
var w = 400,
    h = 200,
    x = pv.Scale.linear(data, function(d){return d.x}).range(0, w),
    y = pv.Scale.linear(0, 4).range(0, h);

/* The root panel. */
var vis = new pv.Panel()
    .width(w)
    .height(h)
    .bottom(20)
    .left(20)
    .right(10)
    .top(5);

/* Y-axis and ticks. */
vis.add(pv.Rule)
    .data(y.ticks(5))
    .bottom(y)
    .strokeStyle(function(d){return d ? "#eee" : "#000"})
  .anchor("left").add(pv.Label)
    .text(y.tickFormat);

/* X-axis and ticks. */
vis.add(pv.Rule)
    .data(x.ticks())
    .visible(function(d){return d})
    .left(x)
    .bottom(-5)
    .height(5)
  .anchor("bottom").add(pv.Label)
    .text(x.tickFormat);

/* The area with top line. */
vis.add(pv.Area)
    .data(data)
    .bottom(1)
    .left(function(d){return x(d.x)})
    .height(function(d){return y(d.y)})
    .fillStyle("rgb(121,173,210)")
  .anchor("top").add(pv.Line)
    .lineWidth(3);
vis.render();




var vis2 = new pv.Panel()
    .width(450)
    .height(350)
  .add(pv.Panel)
    .data(pv.range(2))
    .bottom(function(){ return this.index * 20 + 5})
  .add(pv.Line)
    .data(data)
    .left(function(d){ return x(d.x)})
    .bottom(function(d){ return y(d.y)})
    .lineWidth(5)
  .add(pv.Line)
    .data(data2)
    .left(function(d){ return x(d.x)})
    .bottom(function(d){ return y(d.y)})
    .lineWidth(5);


 vis2.render();