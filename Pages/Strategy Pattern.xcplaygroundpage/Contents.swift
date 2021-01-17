/// # Strategy Pattern
///
/// defines a family of algorithm, encapsulates each
/// one and makes them interchangeable. Strategy pattern
/// lets the algorithm vary independently from clients
/// that uses it

import Foundation

protocol FlyBehavior {
    func fly()
}

class FlyWithWings: FlyBehavior {
    func fly() {
        print("I'm flying!!")
    }
}

class FlyNoWay: FlyBehavior {
    func fly() {
        print("I can't fly")
    }    
}

protocol QuackBehavior {
    func quack()
}

class Quack: QuackBehavior {
    func quack() {
        print("Quack!")
    }
}

class MuteQuack: QuackBehavior {
    func quack() {
        print("<< Silence >>")
    }
}

class Squeak: QuackBehavior {
    func quack() {
        print("Squeak")
    }
}

class Duck {
    var flyBehavior: FlyBehavior
    var quackBehavior: QuackBehavior
    
    init(
        flyBehavior: FlyBehavior,
        quackBehavior: QuackBehavior
    ) {
        self.flyBehavior = flyBehavior
        self.quackBehavior = quackBehavior
    }
    
    func performFly() {
        flyBehavior.fly()
    }
    
    func performQuack() {
        quackBehavior.quack()
    }
    
    func swim() {
        print("All ducks float, even decoys!")
    }
    
    func setFlyBehavior(fb: FlyBehavior) {
        flyBehavior = fb
    }
    
    func setQuackBehavior(qb: QuackBehavior) {
        quackBehavior = qb
    }
}

class MallardDuck: Duck {
    init() {
        let quackBehavior = Quack()
        let flyBehavior = FlyWithWings()
        super.init(flyBehavior: flyBehavior, quackBehavior: quackBehavior)
    }
    
    func display() {
        print("I'm a real Mallard duck")
    }
}

let mallard = MallardDuck()
mallard.performQuack()
mallard.performFly()

print("==========")

class ModelDuck: Duck {
    init() {
        let flyBehavior = FlyNoWay()
        let quackBehavior = Quack()
        super.init(flyBehavior: flyBehavior, quackBehavior: quackBehavior)
    }
    
    func display() {
        print("I'm a model duck")
    }
}

class FlyRocketPowered: FlyBehavior {
    func fly() {
        print("I'm flying with a rocket boost!")
    }
}

let model = ModelDuck()
model.performFly()
model.setFlyBehavior(fb: FlyRocketPowered())
model.performFly()
