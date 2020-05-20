<p align="center">
    <img src="merchant.png" width="600" max-width="90%" alt="merchant" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/Swift-5.2-orange.svg" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/swiftpm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
    <a href="https://cocoapods.org/pods/Merchant">
        <img src="https://img.shields.io/cocoapods/v/Merchant.svg?style=flat" alt="Merchant cocoapods" />
    </a>
    <a href="https://github.com/dubeboy/Merchant/actions">
        <img src="https://github.com/dubeboy/Merchant/workflows/build/badge.svg" alt="build status" />
    </a>
     <a href="/LICENSE">
        <img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=flat" alt="MIT License" />
    </a>
    <a href="https://twitter.com/divinedube">
        <img src="https://img.shields.io/badge/twitter-@divinedube-blue.svg?style=flat" alt="Twitter: @divinedube" />
    </a>
</p>

Merchant is a type-safe HTTP client for iOS, iPadOS, macOS, watchOS and tvOS. Inspired by https://github.com/square/retrofit.

it allows you to simply "property wrap" any codable Swift struct and Merchant will do all the heavy lifting of initiating the HTTP request and decoding the HTTP response data into your model all in a type safe and declarative way.

# Installation

### CocoaPods

Merchant is available through [CocoaPods](https://swift.org/package-manage). To install
it, simply add the following line to your Podfilet

```ruby
pod 'Merchant'
```

### Swift Package Manager 

Merchant is available through [Swift Package Manager](https://cocoapods.org). To install
it, simply add the following to your `Package.swift` file.

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/dubeboy/Merchant.git", from: "0.1.0")
    ],
    ...
)
```

# Usage

## Create decodable models

Create codable models that will represent the JSON response from your API

```swift
struct Main: Codable { ... } // left out for brevity

struct WeatherData: Codable { ... }  // left out for brevity

struct Weather: Codable {
    let weather: [WeatherData]
    let main: Main
}
```

## Initialize Merchant in AppDelegate.

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let builder = Merchant.Builder()
            .baseUrl("http://api.openweathermap.org/data/2.5")
            .build()
        Merchant(builder: builder)
        return true
 }
 ```

 ### Customization Merchant Initilization 

As a minimum to initialize Merchant we would need to simply set the `baseUrl` like in the above code snippet, but Merchant has a few more initialization customization options:
 
Set how verbose the `logger` should output to the debug console. Availbale options are:

- `.body` - log everything all requests and reposense from your API(default).
- `.basic` - log only the request method and request URL.
- `.header` - log only the request url, request headers and response headers.
- `.nothing` - do not log anything.

For example you can set the basic log level like so: 

```swift
builder.logger(.basic)
```

Merchant uses Alamofire under the hood, so `Merchant.Builder` gives you the option to pass in a customized Alamofire `Session`. 

For example you can setup how Merchant handles your TLS security like so: 

```swift
let manager = ServerTrustManager(evaluators: [url: PinnedCertificatesTrustEvaluator()])
let session = Session(serverTrustManager: manager)

builder.session(session)
```

You can learn more on many other ways to customize the Alamofire session object [here](https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md) 

Lastly you can specify a global url query, like an API key for example: 

```swift
builder.query(["api_key": "KEY_HERE"])
```

## Declare your HTTP Requests 
 
 Create your HTTP API client in a declarative way 😌 and wrap your each your properties with one of `@GET`, `@POST`, `PUT`, `@DELETE`, `@PATCH` or `@DELETE` property wrappers depending on the HTTP request you want to make.

 The type of the wrapped property should be a decodable struct/class that represents that particular HTTP JSON response.

 For example we would declare a GET request to this url http://api.openweathermap.org/data/2.5/weather like so:
 
 ```swift
 struct ApplicationClient {
        
    @GET(path = "/weather")
    var getWeather: Weather
    
}
```

### Customize requests

You can customize each of the request like adding headers, formURLEncoding, etc, lets look at this in more detail:

For all the property wrappers, all customization paramaters are optional so you can do this: 

 ```swift
...
@GET
var getWeather: Weather
...
}
```

For all HTTP request methods that require a body like `PUT` and `POST`, you will NEED to specify the `Encodable` body model. 

You can specify the the request body encodable model like so:

 ```swift    
...
@POST(body: Main.self)
var postWeather: Weather // server returns the posted weather + its ID
...
```

You have the option to specificify if the request body should be form urlencoded. `false` by default and you can also specify the headers that go with that request like so:

 ```swift    
...
@POST(body: Main.self, formURLEncoded: true, headers: ["Content-Type": "application/json"])
var postWeather: Weather 
...

```

You can specify a `dynamically generated` URL that depends on some variable.

For example lets say that you want to specify a URL to delete any user given their id, you could declare it like the below snippet and you will then be able to "inject" the actual value of `user_id` when you are making the request.

 ```swift    
...
@DELETE(path="/users/{user_id}")
var deleteUser: Bool
...
```

## Lastly lets make the requests.

Create an instance of the above declared `ApplicationClient` class and call the desired property like so:

```swift
class ViewController: UIViewController {
    let client: ApplicationClient = ApplicationClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        getWeather(city: "Cape Town")
    }
    
    func getWeather(city: String) {    

        let query =  ["q": city, "units": "metric"]
        
        client.$getWeather(query: query) { [weak self] responseObject in
            switch responseObject {
            case .success(let response):
                let weather: Weather = responseObject.body
                ...
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
```

The above code snippet will make a `GET` request to `http://api.openweathermap.org/data/2.5/weather?q=Cape%20Town&units=metric`

### Call site customizations

*All the paramters mentioned below are optional except the body paramter for HTTP methods that require a body.

For `dynamically generated` URLs like the one mentioned above, you SHOULD specify the `path` dictionary to map all url placeholders to their respective values in this case we are mapping `{user_id}` to 56

like so:

```swift
...
client.$deleteUser(path: ["user_id": "56"]) { _ in
    ...
}
... 
```

The above code snippet will generate the URL `/users/56` 

For requests that have a body, you will NEED to specify the `body` parameter as well, taking the `postWeather` example mentioned above, you can initiate that request like this:

```swift
...
let main = Main(...)
client.$postWeather(body: main) { _ in
    ...
} 
```

The above code snippet will make a `POST` request to `http://api.openweathermap.org/data/2.5` with JSON encoded `Main` struct as the `POST` body

## Author

Divine Dube, dubedivine@gmail.com
Twitter: @divinedube

## License

Merchant is available under the MIT license. See the LICENSE file for more info.
