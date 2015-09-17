public protocol SpuriousArgumentExpectation {
    func getValue<U:Equatable>() -> U
    func isEqualTo(value: AnyObject) -> Bool
}

public enum Argument {
    case Anything
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
        if let anyValue: T? = value as? T {
            return self.value == anyValue
        }
        return false
    }
}
