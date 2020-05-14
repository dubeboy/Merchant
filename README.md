# Retroswift

Type-safe HTTP client for the  iOS, iPadOS, macOS, watchOS and tvOS platform inspired by https://github.com/square/retrofit

[![CI Status](https://img.shields.io/travis/dubeboy/RetroSwift.svg?style=flat)](https://travis-ci.org/dubeboy/RetroSwift)
[![Version](https://img.shields.io/cocoapods/v/RetroSwift.svg?style=flat)](https://cocoapods.org/pods/RetroSwift)
[![License](https://img.shields.io/cocoapods/l/RetroSwift.svg?style=flat)](https://cocoapods.org/pods/RetroSwift)
[![Platform](https://img.shields.io/cocoapods/p/RetroSwift.svg?style=flat)](https://cocoapods.org/pods/RetroSwift)

<!-- ## Installation

RetroSwift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RetroSwift'
``` -->

## Setup

1. Create Codable Models

```swift
struct Main: Codable { ... } // left out for brevity

struct WeatherData: Codable { ... }  // left out for brevity

struct Weather: Codable {
    let weather: [WeatherData]
    let main: Main
}
```

2. Initialize Retroswift in AppDelegate, will certainly change over time

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let builder =  RetroSwift.Builder()
            .baseUrl("http://api.openweathermap.org/data/2.5")
            .build()
        RetroSwift(builder: builder)
        return true
 }
 ```
 
 3. Create your HTTP API service in a declarative way, in which you easily wrap your propery with HTTP request methods: `@GET`, `@POST`, `PUT`, `@DELETE`, `@PATCH` and `@DELETE`. The return type of the wrapped property should be the expected Model from the respective HTTP request
 
 ```swift
 struct ApplicationService {
        
    @GET(path="/weather")
    var getWeather: Weather
    
}
```

## Usage 
```swift
class ViewController: UIViewController {
    
    let client: ApplicationService = ApplicationService()
    
    ...
    
    func getWeather(city: String) {      
        let query =  ["q": "Cape Town", "appid": "XXX", "units": "metric"]
        
        client.$getWeather(query: query) { [weak self] response in
            switch response {
            case .success(let object):
                self?.label.text = object.body.weather.first?.desc
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
```

## Author

dubeboy, dubedivine@gmail.com

## License

RetroSwift is available under the MIT license. See the LICENSE file for more info.
