# IWN

![Screenshot](/screenshot-2.png)

IWN is a simple weather widget for [Übersicht](http://tracesof.net/uebersicht/) displaying the current temperature and conditions in the bottom left corner of the desktop. The location is automatically set to the location of the computer.

## Installation

1. Download [Übersicht](http://tracesof.net/uebersicht/)
2. Copy `iwn.widget` to your widgets folder.
3. Sign up to [Dark Sky API](https://darksky.net/dev) and add the obtained api-key in `iwn.coffee`.

## Customization

* The temperature unit can be changed from °C to °F by changing `unit: 'c'` to `unit: 'f'` in `iwn.coffee`.
* A small icon shows the Beaufort number if it is 3 (gentle breeze) or above. This can be deactivated by changing `windscale: 'yes'` to `windscale: 'no'` in `iwn.coffee`.
* The widgets updates every 5 minutes. This can be changed by changing `refreshFrequency: '5min'` in `iwn.coffee`. The time is given in minutes. Note that a free Dark Sky API-key allows 1,000 calls per day.

## Credit & Licences
The design of IWN is heavily inspired by the [Weather Now Widget](https://github.com/briandconnelly/weathernow-widget) by [Brian Connelly](https://github.com/briandconnelly)<br/>
The code is by me and licenced under [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/)<br/>
The [included icons](https://github.com/erikflowers/weather-icons) are by [Erik Flowers](https://github.com/erikflowers) and licenced under [SIL OFL 1.1](https://opensource.org/licenses/OFL-1.1)
