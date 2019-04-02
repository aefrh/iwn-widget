# ------------------------------ CONFIG ------------------------------

# forecast.io api key
apiKey: '<api-key>'

# degree units; 'c' for celsius, 'f' for fahrenheit
unit: 'c'

# refresh every x minutes
time: 5

# ---------------------------- END CONFIG ----------------------------

refreshFrequency: 60000 * @time
exclude: "minutely,hourly,alerts,flags"
command: "echo {}"

makeCommand: (apiKey, location) ->
  "curl -sS 'https://api.forecast.io/forecast/#{apiKey}/#{location}?units=si&exclude=#{@exclude}'"

render: (o) -> """
	<article id="content">
		<div id="icon">
		</div>
		<div id="left">
		<div id="temp">
		</div>
		<div id="condition">
		</div></div>
	</article>
"""

afterRender: (domEl) ->
  geolocation.getCurrentPosition (e) =>
    coords     = e.position.coords
    [lat, lon] = [coords.latitude, coords.longitude]
    @command   = @makeCommand(@apiKey, "#{lat},#{lon}")

    @refresh()

update: (o, dom) ->
	data = JSON.parse(o)

	return unless data.currently?
	t = data.currently.temperature
	c = data.currently.summary

	if @unit == 'f'
		$(dom).find('#temp').html(Math.round(t * 9 / 5 + 32) + ' °F')
	else
		$(dom).find('#temp').html(Math.round(t) + ' °C')

	$(dom).find('#condition').html(c)
	$(dom).find('#icon')[0].innerHTML = @getIcon(data.currently)

style: """
	width 25%
	bottom 3%
	left 1%
	font-family Futura
	font-smooth always
	color rgba(255,255,255,0.4)

	@font-face
		font-family Weather
		src url(iwn.widget/icons.svg) format('svg')
	#left
		padding-left: 70px
	#temp
		font-size 2em
	#condition
		font-size 0.8em
	#icon
		font-size 3em
		vertical-align middle
		float left
		font-family Weather
"""

iconMapping:
	"rain"                :"&#xf019;"
	"snow"                :"&#xf01b;"
	"fog"                 :"&#xf014;"
	"cloudy"              :"&#xf013;"
	"wind"                :"&#xf021;"
	"clear-day"           :"&#xf00d;"
	"mostly-clear-day"    :"&#xf00c;"
	"partly-cloudy-day"   :"&#xf002;"
	"clear-night"         :"&#xf02e;"
	"partly-cloudy-night" :"&#xf031;"
	"unknown"             :"&#xf03e;"

getIcon: (data) ->
		return @iconMapping['unknown'] unless data
		if data.icon.indexOf('cloudy') > -1
			if data.cloudCover < 0.25
				@iconMapping["clear-day"]
			else if data.cloudCover < 0.5
				@iconMapping["mostly-clear-day"]
			else if data.cloudCover < 0.75
				@iconMapping["partly-cloudy-day"]
			else
				@iconMapping["cloudy"]
		else
			@iconMapping[data.icon]
