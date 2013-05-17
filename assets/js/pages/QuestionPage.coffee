class @SummaryChart extends Widget
  bindDom: ->
    @elementId = @element.attr('id')
    @width = @element.width()
    @height = @width

  enhancePage: ->
    @element.css('height', "#{@height}px")
    @svg = d3.select("##{@elementId}").append("svg")
      .attr("width", @width)
      .attr("height", @height)

    @currentData = @element.data('initialData')

    @graphRender = new DonutRender()

  initialize: ->
    @graphRender.attach(@svg, @currentData)

    @eventSource = new EventSource @element.data('eventStream')
    @eventSource.addEventListener 'update', @updateData

  updateData: (e) =>
    console.log e.data

    data = JSON.parse(e.data)
    for item in @currentData
      item.count = data[item.value] if data[item.value]?

    @refresh()

  refresh: ->
    @graphRender.refresh @currentData

class Render
  attach: (@svg, currentData) ->
    @initialize()
    @render(currentData)

  initialize: ->
    @clear()
    @width = @svg.attr('width')
    @height = @svg.attr('height')

  clear: ->
    @svg.select('*').remove()

  render: (currentData) ->

  update: (currentData) ->

class BarRender extends Render
  initialize: ->
    super()

    @graph = @svg
      .append('g')

    @x = d3.scale
      .ordinal()
      .rangeRoundBands([0, @width], .1);

    @y = d3.scale
      .linear()
      .range([@height, 0]);

    @color = d3.scale.category10()

  render: (data) ->
    @x.domain data.map (d)->
      d.value

    @y.domain [0, 30] # TODO Adjust according to count

    @g = @graph.selectAll(".bar")
      .data(data)
      .enter()
      .append("g")
      .attr("class", "bar")

    @g.append('rect')
      .style 'fill', (d) =>
        @color(d.value)
      .attr "x", (d) =>
        @x(d.text)
      .attr("width", @x.rangeBand())
      .attr "y", (d) =>
        @y(d.count)
      .attr "height", (d) =>
        @height - @y(d.count)

    @g.append("text")
      .style("text-anchor", "middle")
      .text (d) ->
        d.data.text

  refresh: (data) ->
    @g.data(data)

    @g.select('rect')
      .transition()
      .attr "y", (d) =>
        @y(d.count)
      .attr "height", (d) =>
        @height - @y(d.count)

class DonutRender extends Render
  initialize: ->
    super()

    @graph = @svg
      .append('g')
      .attr("transform", "translate(#{@width / 2}, #{@height / 2})");

    @color = d3.scale.category10()

    @radius = Math.min(@width, @height) / 2

    @arc = d3.svg.arc()
      .outerRadius(@radius - 10)
      .innerRadius(@radius - 70);

    @pie = d3.layout.pie()
      .sort(null)
      .value (d) ->
        d.count

  adjustData: (data) ->
    allCount = 0
    allCount += part.count for part in data
    return data unless allCount == 0

    $.extend {}, part, { count: .0001 } for part in data

  render: (currentData) ->
    @g = @graph.selectAll(".arc")
      .data(@pie(@adjustData(currentData)))
      .enter().append("g")
      .attr("class", "arc");

    @g.append("path")
      .attr("d", @arc)
      .style "fill", (d) =>
        @color(d.data.value)

    @g.append("text")
      .attr "transform", (d) =>
        "translate(#{@arc.centroid(d)})"
      .attr("dy", ".35em")
      .style("text-anchor", "middle")
      .text (d) ->
        d.data.text

  refresh: (currentData) ->
    @g.data(@pie(@adjustData(currentData)))
    @g.select('path')
      .transition()
      .ease("linear")
      .attr('d', @arc)
    @g.select('text')
      .attr "transform", (d) =>
        "translate(#{@arc.centroid(d)})"