import Foundation

public protocol SpuriousType : class {
    func called(callIdentifier: String, _ parameters: [AnyObject])
    func stub(callIdentifier: String, yield: AnyObject)
    func yield<T>(callIdentifier: String) throws -> T
    func wasCalled(callIdentifier: String, with: [SpuriousArgumentExpectation]) -> Bool
}

public protocol SpuriousLoggerType {
    func logFailureDetail(detail: String)
}

public class Spurious: SpuriousType, CustomStringConvertible {

    private class Logger: SpuriousLoggerType {}

    public var calls: [SpuriousCall] = []
    var stubs: [SpuriousStub] = []
    var testSubjects: [ObjectIdentifier] = []
    public var logger: SpuriousLoggerType = Logger()

    public init() {}

    public init(_ objectIdentifier: ObjectIdentifier) {
        testSubjects.append(objectIdentifier)
    }

    public func called(callIdentifier: String, _ parameters: [AnyObject]) {
        calls.append(SpuriousCall(callIdentifier: callIdentifier, parameters: parameters))
    }

    public func stub(callIdentifier: String, yield: AnyObject) {
        let newStub = SpuriousStub(callIdentifier, yield: yield)

        var stub = findStub(callIdentifier)
        stub != nil ? stub = newStub : stubs.append(newStub)
    }

    public func yield<T>(callIdentifier: String) throws -> T {
        if let stub = findStub(callIdentifier) {
            return stub.yield as! T
        } else {
            throw SpuriousError.NoStub(callIdentifier: callIdentifier, subjects: testSubjects)
        }
    }

    public func wasCalled(callIdentifier: String, with parameters: [SpuriousArgumentExpectation]) -> Bool {
        if calls.count == 0 {
            logger.logFailureDetail("<Spurious> There have been no recorded calls")
            return false
        }

        let callsMatchingIdentifier = calls.filter { (call) -> Bool in
            call.callIdentifier == callIdentifier
        }
        if callsMatchingIdentifier.count == 0 {
            logger.logFailureDetail("<Spurious> No calls identified by '\(callIdentifier)'. Received calls:\n\(calls)")
            return false
        }

        let index = callsMatchingIdentifier.indexOf { (call) -> Bool in
            if parameters.count != call.parameters?.count {
                return false
            }
            for var i = 0; i < parameters.count; i++ {
                let expectedParameter = parameters[i]
                let calledParameter = call.parameters![i]

                if !expectedParameter.isEqualTo(calledParameter) {
                    return false
                }
            }

            return true
        }

        if index == nil {
            logger.logFailureDetail("<Spurious> No calls with matching parameters for identifier '\(callIdentifier)'. Received calls:\n\(callsMatchingIdentifier)")
            return false
        }

        return true
    }

    public var description: String {
        return "<Spurious> \(ObjectIdentifier(self).hashValue) calls: \(self.calls.count) stubs: \(self.stubs.count)"
    }

}

extension Spurious {

    public func findStub(callIdentifier: String) -> SpuriousStub? {
        let index = stubs.indexOf { (stub) -> Bool in
            stub.callIdentifier == callIdentifier
        }
        return index != nil ? stubs[index!] : nil
    }

    public func findCall<T:AnyObject where T:Equatable>(callIdentifier: String, with parameters: [T]) -> SpuriousCall? {
        return nil
    }

}

extension SpuriousLoggerType {
    func logFailureDetail(detail: String) {
        print(detail)
    }
}

public class SpuriousCall: CustomStringConvertible {

    let callIdentifier: String
    var parameters: [AnyObject]?

    public var description: String {
        return "<SpuriousCall> \(ObjectIdentifier(self).hashValue) identifier: '\(self.callIdentifier)' parameters: \(self.parameters!)"
    }

    public init(callIdentifier: String, parameters: [AnyObject]?) {
        self.callIdentifier = callIdentifier
        self.parameters = parameters
    }

}

public class SpuriousStub {
    let callIdentifier: String
    let yield: AnyObject

    init(_ callIdentifier: String, yield: AnyObject) {
        self.callIdentifier = callIdentifier
        self.yield = yield
    }
}

public enum SpuriousError: ErrorType, CustomStringConvertible {
    case NoStub(callIdentifier: String, subjects: [ObjectIdentifier])

    public var description: String {
        get {
            switch self {
            case let NoStub(callIdentifier, subjects):
                return "There is no stub registered for (\(callIdentifier)) with test subjects: \(subjects)"
            }
        }
    }
}

extension ObjectIdentifier: CustomStringConvertible {
    public var description: String {
        get {
            return "ObjectIdentifier: \(self.hashValue)"
        }
    }
}
