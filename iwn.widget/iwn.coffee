# ------------------------------ CONFIG ------------------------------

# forecast.io api key
apiKey: '<api-key>'

# degree units; 'c' for celsius, 'f' for fahrenheit
unit: 'c'

# refresh every x minutes
refreshFrequency: '5min'

# show Beaufort wind scale; 'yes' or 'no'
windscale: 'yes'

# ---------------------------- END CONFIG ----------------------------

exclude: "minutely,hourly,daily,alerts,flags"
command: "echo {}"

makeCommand: (apiKey, location) ->
	"curl -sS 'https://api.darksky.net/forecast/#{apiKey}/#{location}?units=si&exclude=#{@exclude}'"

render: (o) -> """
	<article id="content">
		<div id="icon">
		</div>
		<div id="windscale">
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

	if @windscale == 'yes'
		$(dom).find('#windscale')[0].innerHTML = @getWind(data.currently)

style: """
	width 25%
	bottom 1.5em
	left 1%
	font-family Avenir Next LT Pro, Futura
	font-smooth always
	color rgba(255,255,255,0.4)

	@font-face
		font-family Weather
		src url(iwn.widget/icons.svg) format('svg')
	#left
		padding-left 80px
	#temp
		font-size 2em
	#condition
		font-size 0.8em
	#icon
		font-size 3em
	#windscale
		font-size 1.5em
		position fixed
		bottom .5em
	#icon, #windscale
		vertical-align middle
		float left
		font-family Weather
"""

iconMapping:
	"rain"                :"&#xf019;"
	"snow"                :"&#xf01b;"
	"fog"                 :"&#xf014;"
	"cloudy"              :"&#xf013;"
	"wind"                :"&#xf050;"
	"clear-day"           :"&#xf00d;"
	"mostly-clear-day"    :"&#xf00c;"
	"partly-cloudy-day"   :"&#xf002;"
	"clear-night"         :"&#xf02e;"
	"partly-cloudy-night" :"&#xf086;"
	"unknown"             :"&#xf03e;"
	"sleet"               :"&#xf0b5;"
	"hail"                :"&#xf03e;"
	"thunderstorm"        :"&#xf03e;"
	"tornado"             :"&#xf03e;"
	"wind3"               :"&#xf0ba;"
	"wind4"               :"&#xf0bb;"
	"wind5"               :"&#xf0bc;"
	"wind6"               :"&#xf0bd;"
	"wind7"               :"&#xf0be;"
	"wind8"               :"&#xf0bf;"
	"wind9"               :"&#xf0c0;"
	"wind10"              :"&#xf0c1;"
	"wind11"              :"&#xf0c2;"
	"wind12"              :"&#xf0c3;"
	"none"                :""

getIcon: (data) ->
		return @iconMapping['unknown'] unless data
		if data.icon.indexOf('partly-cloudy-day') > -1
			if data.cloudCover < 0.25
				@iconMapping["clear-day"]
			else if data.cloudCover < 0.5
				@iconMapping["mostly-clear-day"]
			else if data.cloudCover < 0.75
				@iconMapping["partly-cloudy-day"]
			else
				@iconMapping["cloudy"]
		if data.icon.indexOf('wind') > -1
			if data.windSpeed > 32.7
				@iconMapping["wind12"]
			else if data.windSpeed > 28.5
				@iconMapping["wind11"]
			else if data.windSpeed > 24.5
				@iconMapping["wind10"]
			else if data.windSpeed > 20.8
				@iconMapping["wind9"]
			else if data.windSpeed > 17.2
				@iconMapping["wind8"]
			else if data.windSpeed > 13.9
				@iconMapping["wind7"]
			else if data.windSpeed > 10.8
				@iconMapping["wind6"]
			else if data.windSpeed > 8
				@iconMapping["wind5"]
			else if data.windSpeed > 5.5
				@iconMapping["wind4"]
			else if data.windSpeed > 3.4
				@iconMapping["wind3"]
		else
			@iconMapping[data.icon]
getWind: (data) ->
		if data.icon.indexOf('wind') > -1
			@iconMapping["none"]
		else if data.windSpeed > 32.7
			@iconMapping["wind12"]
		else if data.windSpeed > 28.5
			@iconMapping["wind11"]
		else if data.windSpeed > 24.5
			@iconMapping["wind10"]
		else if data.windSpeed > 20.8
			@iconMapping["wind9"]
		else if data.windSpeed > 17.2
			@iconMapping["wind8"]
		else if data.windSpeed > 13.9
			@iconMapping["wind7"]
		else if data.windSpeed > 10.8
			@iconMapping["wind6"]
		else if data.windSpeed > 8
			@iconMapping["wind5"]
		else if data.windSpeed > 5.5
			@iconMapping["wind4"]
		else if data.windSpeed > 3.4
			@iconMapping["wind3"]
		else
			@iconMapping["none"]
