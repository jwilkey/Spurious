import Foundation

public protocol SpuriousType : class {
    func called(callIdentifier: String)
    func stub(callIdentifier: String, yield: AnyObject)
    func yield<T>(callIdentifier: String) throws -> T
    func didCall(callIdentifier: String) -> Bool
}

public class Spurious: SpuriousType, CustomStringConvertible {

    public var calls: [SpuriousCall] = []
    var stubs: [SpuriousStub] = []

    public init() {}

    public func called(callIdentifier: String) {
        calls.append(SpuriousCall(callIdentifier: callIdentifier))
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
            throw SpuriousError.NoStub
        }
    }

    public func didCall(callIdentifier: String) -> Bool {
        return findCall(callIdentifier) != nil
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

    public func findCall(callIdentifier: String) -> SpuriousCall? {
        let index = calls.indexOf { (call) -> Bool in
            call.callIdentifier == callIdentifier
        }
        return index != nil ? calls[index!] : nil
    }

}

public class SpuriousCall {
    let callIdentifier: String

    init(callIdentifier: String) {
        self.callIdentifier = callIdentifier
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

enum SpuriousError: ErrorType {
    case NoStub
}

