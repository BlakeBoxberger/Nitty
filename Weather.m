WeatherPreferences *weatherPreferences = [NSClassFromString(@"WeatherPreferences") sharedPreferences];

static NSString *getWeatherString() {
  City *city = [[weatherPreferences loadSavedCities] objectAtIndex:0];
  if(city) {
    HourlyForecast *hourlyForecast = city.hourlyForecasts[0];
    if([weatherPreferences isCelsius]) {
      WATemperature *celsiusTemp = hourlyForecast.temperature;
      return [NSString stringWithFormat:@"%i °C", (int)celsiusTemp.celsius];
    }
    else {
      WATemperature *fahrenheitTemp = hourlyForecast.temperature;
      return [NSString stringWithFormat:@"%i °F", (int)fahrenheitTemp.fahrenheit];
    }
  }
  else {
    return @"0 °F";
  }
}
