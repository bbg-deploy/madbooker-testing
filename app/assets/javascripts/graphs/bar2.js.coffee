@module 'MB', ->
  @module "Graphs", ->
    @Bar2 = (->

          
      series = (data)->
        data.map (o)->
          {
            name: o.city
            data: o.visits
            marker: { symbol: 'circle'}
          }

      render: (selector, title, data, categories, yTitle)->
        data[0].dataLabels = {
          enabled: true,
          rotation: -90,
          color: '#ffffff',
          align: 'right',
          x: 4,
          y: 10,
          style: {
            fontSize: '13px',
            fontFamily: 'Verdana, sans-serif',
            textShadow: '0 0 3px black'
          }
        }
        $(selector).highcharts {
          chart: { type: 'column', margin: [ 50, 50, 100, 80] }
          title: { text: title, x: -20 }
          xAxis: {
            categories: categories
            labels: {
              rotation: -45,
              align: 'right',
              style: {
                fontSize: '13px',
                fontFamily: 'Verdana, sans-serif'
              }
            }
          }
          yAxis: {
            title: { text: yTitle }
          }
          legend: { enabled: false }
          series: data
        }
        
      init: ->
          
      )()
      