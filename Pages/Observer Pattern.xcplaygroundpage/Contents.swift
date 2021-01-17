//: [Previous](@previous)

/// # Strategy Pattern

import Foundation

protocol Subjectable {
    func registerObserver(observer: Observerable)
    func removeObserver(observer: Observerable)
    func notifyObservers()
}

protocol Observerable {
    func update(temperature: Float, humidity: Float, pressure: Float)
    
    func isEqual(to: Observerable) -> Bool
}

extension Observerable where Self : Equatable {
    func isEqual(to: Observerable) -> Bool {
        return (to as? Self).flatMap({ $0 == self }) ?? false
    }
}

protocol DisplayElementable {
    func display()
}

class WeatherData: Subjectable {
    
    var observers: [Observerable] = []
    var temperature: Float = 0
    var humidity: Float = 0
    var pressure: Float = 0
    
    func registerObserver(observer: Observerable) {
        observers.append(observer)
    }
    
    func removeObserver(observer: Observerable) {
        observers = observers.filter({ !$0.isEqual(to: observer) })
    }
    
    func notifyObservers() {
        for observer in observers {
            observer.update(temperature: temperature, humidity: humidity, pressure: pressure)
        }
    }
    
    func measurementChanged() {
        notifyObservers()
    }
    
    func setMeasurements(temperature: Float, humidity: Float, pressure: Float) {
        self.temperature = temperature
        self.humidity = humidity
        self.pressure = pressure
        measurementChanged()
    }
}

class CurrentConditionDisplay: Observerable, DisplayElementable, Equatable {
    private let id = UUID()
    private var temperature: Float = 0
    private var humidity: Float = 0
    private var weatherData: WeatherData
    
    init(weatherData: WeatherData) {
        self.weatherData = weatherData
        weatherData.registerObserver(observer: self)
    }
    func update(temperature: Float, humidity: Float, pressure: Float) {
        self.temperature = temperature
        self.humidity = humidity
        display()
    }
        
    func display() {
        print("Current conditions \(temperature) F degrees and \(humidity)% humidity")
    }
    
    static func == (lhs: CurrentConditionDisplay, rhs: CurrentConditionDisplay) -> Bool {
        return lhs.id == rhs.id
    }
}

class StatisticsDisplay: Observerable, DisplayElementable, Equatable {
    private let id = UUID()
    private var humidity: Float = 0
    private var weatherData: WeatherData
    private var maxTemperature: Float
    private var minTemperature: Float
    private var averageTemperature: Float

    init(weatherData: WeatherData) {
        self.weatherData = weatherData
        self.minTemperature = weatherData.temperature
        self.maxTemperature = weatherData.temperature
        self.averageTemperature = weatherData.temperature
        weatherData.registerObserver(observer: self)
    }
    func update(temperature: Float, humidity: Float, pressure: Float) {
        self.minTemperature = min(minTemperature, temperature)
        self.maxTemperature = max(maxTemperature, temperature)
        self.averageTemperature = (minTemperature + maxTemperature) / 2
        display()
    }
    
    func display() {
        print("Minimum temperature: \(minTemperature) F degrees")
        print("Average temperature: \(averageTemperature) F degrees")
        print("Max temperature: \(maxTemperature) F degrees")
    }
    
    static func == (lhs: StatisticsDisplay, rhs: StatisticsDisplay) -> Bool {
        return lhs.id == rhs.id
    }
}

let weatherData = WeatherData()
let currentDisplay = CurrentConditionDisplay(weatherData: weatherData)
let statisticsDisplay = StatisticsDisplay(weatherData: weatherData)

weatherData.setMeasurements(temperature: 80, humidity: 65, pressure: 30.4)
print("=======")
weatherData.setMeasurements(temperature: 82, humidity: 70, pressure: 29)
print("=======")
weatherData.setMeasurements(temperature: 78, humidity: 90, pressure: 29.2)

//: [Next](@next)
