public protocol SpuriousArgumentExpectation {
    func getValue<U:Equatable>() -> U
    func isEqualTo(value: AnyObject) -> Bool
}

public enum Argument {
    case Anything
}

prefix operator <- {}

public prefix func <-<T:Equatable>(eq: T) -> With<T> {
    return With(eq)
}

public func with<T:Equatable>(value: T) -> With<T> {
    return With(value)
}

public func and<T:Equatable>(value: T) -> With<T> {
    return With(value)
}

public func ==<T:Equatable>(lhs: With<T>, rhs: With<T>) -> Bool {
    return lhs.value == rhs.value
}

public func ==<T:Equatable>(lhs: T, rhs: With<T>) -> Bool {
    return lhs == rhs.value
}

public func ==<T:Equatable>(lhs: With<T>, rhs: Argument) -> Bool {
    return lhs.value is Argument && lhs.value as? Argument == Argument.Anything && rhs == Argument.Anything
}

public func ==<T:Equatable>(lhs: With<T>, rhs: T) -> Bool {
    return lhs.value == rhs
}

public class With<T: Equatable>: SpuriousArgumentExpectation, Equatable {
    var value: T

    public init(_ value: T) {
        self.value = value
    }

    public func getValue<U: Equatable>() -> U {
        return self.value as! U
    }

    public func isEqualTo(value: AnyObject) -> Bool {
        if self == Argument.Anything {
            return true
        }
        if let anyValue: T? = value as? T {
            return self.value == anyValue
        }
        return false
    }
}
