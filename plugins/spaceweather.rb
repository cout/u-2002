require 'open-uri'
require 'ostruct'

module Plugins

class SpaceWeather
  include Cinch::Plugin

  match /spaceweather/

  def execute(m)
    m.reply(space_weather())
  end

  def space_weather
    space_weather = OpenStruct.new

    # http://www.swpc.noaa.gov/Data/index.html

    sgas = open('http://www.swpc.noaa.gov/ftpdir/latest/SGAS.txt') { |f| f.read }
    daily_indices = sgas.slice(/Daily Indices:.*?\n(.*?)\n/mi, 1)
    space_weather.sunspot_number = daily_indices.slice(/\bSSN\s+(\d+)/, 1).to_i
    space_weather.solar_flux_10cm = daily_indices.slice(/10 cm\s+(\d+)/, 1).to_i

    ace_swepam = open('http://www.swpc.noaa.gov/ftpdir/lists/ace/ace_swepam_1m.txt') { |f| f.read }
    ace_swepam.each_line do |line|
      next if line[0] == ?: or line[0] == ?#
      fields = line.split

      if fields[7] != nil and fields[7] != '-9999.9' then
        space_weather.solar_wind_density = fields[7]
      end

      if fields[8] != nil and fields[8] != '-9999.9' then
        space_weather.solar_wind_speed = fields[8]
      end
    end

    daily_solar_data = open('http://www.swpc.noaa.gov/ftpdir/latest/DSD.txt') { |f| f.read }
    daily_solar_data.each_line do |line|
      next if line[0] == ?: or line[0] == ?#
      fields = line.split

      # space_weather.sunspot_number = fields[4]
      space_weather.xray_background_flux = fields[8]
      space_weather.class_c_solar_flares = fields[9]
      space_weather.class_m_solar_flares = fields[10]
      space_weather.class_x_solar_flares = fields[11]
    end

    geomagnetic_data = open('http://www.swpc.noaa.gov/ftpdir/latest/AK.txt') { |f| f.read }
    geomagnetic_data.each_line do |line|
      next if line[0] == ?: or line[0] == ?#
      if line =~ /Planetary\(estimated Ap\)(.*)/ then
        fields = $1.split
        space_weather.current_k_index = fields[1] if fields[1] != '-1'
        space_weather.day_k_index = fields[8] if fields[8] != '-1'
      end
    end

    s = ''
    s << "Solar wind speed"
    s << ": #{space_weather.solar_wind_speed} km/s"
    s << ", density: #{space_weather.solar_wind_density} p/cc"
    s << "; solar flares (24hr)"
    s << ": #{space_weather.class_c_solar_flares} class C"
    s << ", #{space_weather.class_m_solar_flares} class M"
    s << ", #{space_weather.class_x_solar_flares} class X"
    s << "; sunspot number: #{space_weather.sunspot_number}"
    s << "; 10 cm solar flux: #{space_weather.solar_flux_10cm} sfu"
    s << "; planetary K-index: #{space_weather.current_k_index}"
    s << " (24hr avg: #{space_weather.day_k_index})"

    return s
  end
end

end

