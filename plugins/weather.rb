require 'cgi'
require 'open-uri'
require 'rexml/document'

module Plugins

class Weather
  include Cinch::Plugin

  match /weather\s*(.*)/i,
        method: :weather,
        help: "Tells the current weather for the given location"

  match /forecast\s*(.*)/i,
        method: :forecast,
        help: "Tells the forecast for the given location"

  match /i live in (.*)/i,
        method: :set_location,
        help: "Set's your location"

  match /where do i live/i,
        method: :show_my_location,
        help: "Set's your location"

  match /where does (.*?) live/i,
        method: :show_location,
        help: "Set's your location"

  match /metar\s+(.*)/i,
        method: :metar,
        help: "Get the raw metar data for the given airport"

  set help: "weather <where> - tells the current weather for the given location\n" + \
            "forecast <where> - tells the forecast for the given location\n" + \
            "I live in <where> - sets your location\n" + \
            "Where do I live / Where does <who> live - tells a user's location"

  def initialize(*args)
    super(*args)
    load_locations
  end

  WEATHER_LOCATIONS = 'weather_locations.yaml'

  def load_locations
    if File.exists?(WEATHER_LOCATIONS) then
      @locations = YAML.load_file(WEATHER_LOCATIONS)
    else
      @locations = { }
    end
  end

  def save_locations
    synchronize(:update) do
      File.open(WEATHER_LOCATIONS, 'w') do |out|
        YAML.dump(@locations, out)
      end
    end
  end

  def set_location(m, where)
    @locations[m.user.nick] = where
    save_locations
    m.reply("You now live in #{where}")
  end

  def show_location(m, who)
    if @locations[who] then
      m.reply("#{who} lives in #{@locations[who]}")
    else
      m.reply("I don't know where #{who} lives")
    end
  end

  def show_my_location(m)
    if @locations[m.user.nick] then
      m.reply("You live in #{@locations[m.user.nick]}")
    else
      m.reply("I don't know where you live")
    end
  end

  def find_location(where, nick)
    if @locations[where] then
      where = @locations[where]
    elsif where == '' and @locations[nick] then
      where = @locations[nick]
    end
    return where
  end

  def weather(m, where)
    where = find_location(where, m.user.nick)
    m.reply(get_weather(where))
  end

  def forecast(m, where)
    where = find_location(where, m.user.nick)
    m.reply(get_forecast(where))
  end

  def metar(m, where)
    m.reply(get_metar(where))
  end

  def get_weather(where)
    bot.loggers.info "Getting weather for #{where}"
    file = open("http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml?query=#{CGI.escape(where)}")
    doc = REXML::Document.new(file)

    e = doc.root.elements
    location = e['display_location/full'].text
    station = e['station_id'].text
    time = Time.at(e['observation_epoch'].text.to_i).strftime('%H:%M:%S')
    desc = e['weather'].text
    temp = e['temperature_string'].text
    heat_index = e['heat_index_string'].text
    humidity = e['relative_humidity'].text
    wind_dir = (e['wind_dir'].text || '').downcase
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
    # file = open("http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=#{CGI.escape(wherer}")
    # doc = REXML::Document.new(file)

    # e = doc.root.elements
    # forecast = e['simpleforecast']

    return "I haven't implemented forecast yet"
  end

  def get_metar(where)
    bot.loggers.info "Getting METAR for #{where}"
    file = open("http://w1.weather.gov/data/METAR/#{CGI.escape(where)}.1.txt")
    results = file.read.split("\n")
    return results[3]
  end
end

end

