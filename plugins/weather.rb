require 'cgi'
require 'open-uri'
require 'rexml/document'

class WeatherPlugin
  include Cinch::Plugin

  match /weather (.*)/,
        method: :weather,
        help: "Tells the current weather for the given location"

  match /forecast (.*)/,
        method: :forecast,
        help: "Tells the forecast for the given location"

  set help: "weather <where> - tells the current weather for the given location\n" + \
            "forecast <where> - tells the forecast for the given location"

  def weather(m, where)
    m.reply(get_weather(where))
  end

  def forecast(m, where)
    m.reply(get_forecast(where))
  end

  def get_weather(where)
    bot.loggers.info "Getting weather for #{where}"
    file = open("http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml?query=#{where}")
    doc = REXML::Document.new(file)

    e = doc.root.elements
    location = e['display_location/full'].text
    station = e['station_id'].text
    time = Time.at(e['observation_epoch'].text.to_i).strftime('%H:%M:%S')
    desc = e['weather'].text
    temp = e['temperature_string'].text
    heat_index = e['heat_index_string'].text
    humidity = e['relative_humidity'].text
    wind_dir = e['wind_dir'].text.downcase
    wind_mph = e['wind_mph'].text
    wind_gust_mph = e['wind_gust_mph'].text

    case wind_dir
    when /north/, /south/, /east/, /west/
      # ok
    else
      wind_dir = wind_dir.upcase
    end

    weather = "Weather for #{location} (#{station}) at #{time}"
    weather << ": temperature #{temp}"
    weather << ", heat index #{heat_index}" if heat_index != "NA"
    weather << ", humidity #{humidity}"
    weather << ", wind #{wind_dir} at #{wind_mph} mph"
    weather << " with gusts up to #{wind_gust_mph} mph" if wind_gust_mph

    return weather
  end

  def get_forecast(where)
    # file = open("http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=#{where}")
    # doc = REXML::Document.new(file)

    # e = doc.root.elements
    # forecast = e['simpleforecast']

    return "I haven't implemented forecast yet"
  end
end

