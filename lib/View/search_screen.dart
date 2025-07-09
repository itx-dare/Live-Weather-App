import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/Model/weather_model.dart';
import 'package:weather_app/Utils/location_storage_service.dart';
import 'package:weather_app/Utils/weather_service.dart';
import 'package:weather_app/Utils/saved_location.dart';
import 'package:weather_app/View/weather_view_screen.dart';
import 'package:weather_app/widgets/get_weather_icon.dart';

class SearchScreen extends StatefulWidget {
  final List<WeatherModel> weatherModel;

  const SearchScreen({required this.weatherModel, super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  final LocationStorageService _storageService = LocationStorageService();
  List<SavedLocation> _savedLocations = [];
  List<WeatherModel> _searchResults = [];
  bool _isSearching = false;
  bool _showSavedLocations = true;

  @override
  void initState() {
    super.initState();
    _loadSavedLocations();
    _searchController.addListener(_handleSearchChange);
  }

  @override
  void dispose() {
    _searchController.removeListener(_handleSearchChange);
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchChange() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _showSavedLocations = true;
        _searchResults = [];
        _isSearching = false;
      });
    } else {
      setState(() {
        _showSavedLocations = false;
      });
    }
  }

  Future<void> _loadSavedLocations() async {
    _savedLocations = await _storageService.getSavedLocations();
    setState(() {});
  }

  Future<void> _searchCity(String query) async {
    if (query.isEmpty) {
      setState(() {
        _showSavedLocations = true;
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _showSavedLocations = false;
      _isSearching = true;
    });

    try {
      final weather = await _weatherService.getWeather(query);
      setState(() {
        _searchResults = [weather];
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to find city: $query')),
      );
    }
  }

  Future<void> _saveLocation(WeatherModel weather) async {
    final location = SavedLocation(
      city: weather.location,
      temperature: weather.currentCondition.tempC,
      weatherDesc: weather.currentCondition.weatherDesc,
      savedTime: DateTime.now(),
    );

    await _storageService.saveLocation(location);
    await _loadSavedLocations();
    _searchController.clear();
    setState(() {
      _searchResults = [];
      _showSavedLocations = true;
    });
  }

  Future<void> _deleteLocation(String city) async {
    await _storageService.deleteLocation(city);
    await _loadSavedLocations();
  }

  @override
  Widget build(BuildContext context) {
    final myHeight = MediaQuery.of(context).size.height;
    final myWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff060720),
        body: SizedBox(
          height: myHeight,
          width: myWidth,
          child: Column(
            children: [
              SizedBox(height: myHeight * 0.03),
              const Text(
                'Pick location',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              SizedBox(height: myHeight * 0.03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: myWidth * 0.05),
                child: Column(
                  children: [
                    Text(
                      'Find the area or city that you want to know',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      'the detailed weather info at this time',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: myHeight * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: myWidth * 0.06),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: myWidth * 0.05,
                          ),
                          child: TextFormField(
                            controller: _searchController,
                            onChanged: _searchCity,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Image.asset(
                                'assets/icons/search_unselected.png',
                                height: myHeight * 0.025,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                              hintText: 'Search City or State...',
                              hintStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: myHeight * 0.04),
              Expanded(child: _buildContent(myHeight, myWidth)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(double height, double width) {
    if (_isSearching) {
      return Center(
        child: SizedBox(
          height: height * 0.4,
          child: Lottie.asset(
            'assets/animation/cloud_loading.json',
            fit: BoxFit.contain,
            repeat: true,
          ),
        ),
      );
    }

    if (_searchResults.isNotEmpty) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final weather = _searchResults[index];
          return _buildWeatherCard(
            weather,
            height,
            width,
            isSearchResult: true,
          );
        },
      );
    }

    if (_showSavedLocations) {
      if (_savedLocations.isEmpty) {
        return Center(
          child: Text(
            'No saved locations',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 18,
            ),
          ),
        );
      }
      return GridView.custom(
        padding: EdgeInsets.symmetric(horizontal: width * 0.01),
        gridDelegate: SliverStairedGridDelegate(
          mainAxisSpacing: 13,
          startCrossAxisDirectionReversed: false,
          pattern: [
            StairedGridTile(0.5, 3 / 2.2),
            StairedGridTile(0.5, 3 / 2.2)
          ],
        ),
        childrenDelegate: SliverChildBuilderDelegate(
          childCount: _savedLocations.length,
              (context, index) {
            final location = _savedLocations[index];
            return _buildSavedLocationCard(location, height, width);
          },
        ),
      );
    }

    return Center(
      child: Text(
        'No results found',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.5),
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildWeatherCard(
      WeatherModel weather,
      double height,
      double width, {
        bool isSearchResult = false,
      }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${weather.currentCondition.tempC}°C',
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        weather.currentCondition.weatherDesc,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    getWeatherIcon(weather.currentCondition.weatherDesc),
                    height: height * 0.06,
                    width: width * 0.15,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    weather.location,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  if (isSearchResult)
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _searchController.clear();
                        setState(() {
                          _searchResults = [];
                          _showSavedLocations = true;
                        });
                        Get.to(() => WeatherViewScreen(weatherModel: weather));
                        _saveLocation(weather);
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavedLocationCard(
      SavedLocation location,
      double height,
      double width,
      ) {
    return GestureDetector(
      onTap: () async {
        Get.to(() => WeatherViewScreen(city: location.city));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${location.temperature}°C',
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        SizedBox(
                          width: 100,
                          child: Text(
                            location.weatherDesc,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      getWeatherIcon(location.weatherDesc),
                      height: height * 0.06,
                      width: width * 0.15,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      location.city,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteLocation(location.city),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}