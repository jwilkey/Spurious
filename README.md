# Spurious

[![Version](https://img.shields.io/cocoapods/v/Spurious.svg?style=flat)](http://cocoapods.org/pods/Spurious)
[![License](https://img.shields.io/cocoapods/l/Spurious.svg?style=flat)](http://cocoapods.org/pods/Spurious)
[![Platform](https://img.shields.io/cocoapods/p/Spurious.svg?style=flat)](http://cocoapods.org/pods/Spurious)

Why so spurious? Because sometimes the real thing is just too risky.    

```
databaseSaver.save()        // real records, yikes!
requestMaker.makeRequest()  // pound that server!
rainMaker.makeRain()        // goodness no!
```

Spurious makes it easier to stub and fake object dependencies when testing.  

## Usage

Given

```Swift
class FakeRainMaker: RainMaker, SpuriousTestable {
    func makeRain() -> String {
        // will register any calls with Spurious, identified by String "makeRain()"
        return callSpurious() 
    }
    
    func rainfallTotals(cityName: String, month: Int) -> Int {
        // will register any calls with Spurious, identified by String "rainfallTotals(_:month:)"
        return callSpurious([cityName, month])
    }
}
```

When

```Swift
rainMaker = FakeRainMaker()
subject.rainMaker = rainMaker
rainMaker.stub("makeRain()", yield: "Chocolate rain")
```

Fantastic. And then (using Quick matchers):

```Swift
let rain = subject.precipitation()
expect(rainMaker.wasCalled("makeRain()")).to(beTruthy())
expect(rain) == "Chocolate rain"
```

Using Swift 2 ability to provide default implementations for protocols, an instance of a particular class or protocol can be declared as also implementing protocol SpuriousTestable, and will automatically gain the ability to register stubs and verify function calls through an instance of Spurious.  

<b>More...</b>

```Swift
rainMaker.stub("rainfallTotals(_:month:)", yield: 5555)
let totalInches = subject.getLocalRainLastJanuary()

expect(rainMaker.wasCalled("rainfallTotals(_:month:)", <-"UserCity", <-1)) == true
// can also be written as:
expect(rainMaker.wasCalled("rainfallTotals(_:month:)", with("UserCity"), and(1))) == true

expect(totalInches) == 5555
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
Swift 2.0

## Installation

Spurious is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Spurious"
```

## Author

Justin Wilkey

## License

Spurious is available under the MIT license. See the LICENSE file for more info.
