@module 'MB', ->
  @module "Graphs", ->
    @Line = (->

      
      series = (data)->
        out = []
        Object.keys(data[0]).each (name)->
          unless name is "date"
            out.add {name: name, data: data.map (o)-> o[name]}
        out.map (o)->
          {
            name: o.name.titleize()
            data: o.data.map (x)->+x
            marker: { symbol: 'circle'}
          }
          

      render: (selector, title, data, full_month, side_title)->
        side_title ?= "Amount"
        $(selector).highcharts {
          title: { text: title, x: -20 }
          #subtitle: { text: 'subtitle', x: -20}
          xAxis: {
            categories: data.map (o)-> 
              if full_month
                Date.create( o.date).format('{Month} {day} {yyyy}')
              else
                Date.create( o.date).format('{Month} {yyyy}')
            labels: {
              rotation: -45,
              align: 'right',
              style: {
                fontSize: '10px',
                fontFamily: 'Verdana, sans-serif'
              }
            }
          }
          yAxis: {
            title: { text: side_title }
            plotLines: [{ value: 0, width: 1, color: '#808080' }]
          }
          legend: { layout: 'vertical', align: 'right', verticalAlign: 'middle', borderWidth: 0 }
          series: series data
        }
        
      init: ->
          
      )()





  
