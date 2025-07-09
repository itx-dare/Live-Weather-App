String getWeatherIcon(String description) {
  switch (description.toLowerCase()) {
    case 'sunny':
      return 'assets/weather/sunny.png';
    case 'clear':
      return 'assets/weather/clear.png';
    case 'haze':
      return 'assets/weather/haze.png';
    case 'partly cloudy':
      return 'assets/weather/partly_cloudy.png';
    case 'cloudy':
      return 'assets/weather/cloudy.png';
    case 'overcast':
      return 'assets/weather/overcast.png';
    case 'mist':
      return 'assets/weather/mist.png';
    case 'fog':
      return 'assets/weather/fog.png';
    case 'light rain':
      return 'assets/weather/light_rain.png';
    case 'heavy rain':
      return 'assets/weather/heavy_rain.png';
    case 'thunderstorm':
      return 'assets/weather/thunderstorm.png';
    default:
      return 'assets/weather/cloudy.png';
  }
}