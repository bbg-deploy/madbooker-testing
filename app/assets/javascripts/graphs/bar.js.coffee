@module 'MB', ->
  @module "Graphs", ->
    @Bar = (->

      series = (data)->
        out = []
        data.each (d)->
          d.urls.each (pair)->
            current = out.find (o)-> o.name is pair.url
            if current
              current.data.add pair.count
            else
              out.add {name: pair.url, data: [pair.count]}
        out.map (o)->
          {
            name: o.name.titleize()
            data: o.data.map (x)->+x
            marker: { symbol: 'circle'}
          }
          

      render: (selector, title, data)->
        p data
        $(selector).highcharts {
          chart: { type: 'column', margin: [ 50, 50, 100, 80] }
          title: { text: title, x: -20 }
          xAxis: {
            categories: data.map (o)-> 
              Date.create( o.date).format('{Month} {yyyy}')
          }
          yAxis: {
            title: { text: 'Amount' }
          }
          legend: { layout: 'vertical', align: 'right', verticalAlign: 'middle', borderWidth: 0 }
          series: series data
        }
        
      init: ->
          
      )()
      