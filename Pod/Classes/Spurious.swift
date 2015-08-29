import Foundation

public class Spurious {
    
    static let sharedInstance = Spurious()
    
    var calls: [SpuriousCall] = []
    var stubs: [SpuriousStub] = []
    
    public func called(target: SpuriousTestable, callIdentifier: String) {
        calls.append(SpuriousCall(target, callIdentifier: callIdentifier))
    }
    
    public func stub(target: SpuriousTestable, callIdentifier: String, yield: AnyObject) {
        let newStub = SpuriousStub(target, callIdentifier: callIdentifier, yield: yield)

        var stub = findStub(target, callIdentifier: callIdentifier)
        stub != nil ? stub = newStub : stubs.append(newStub)
    }
    
    public func yield<T>(target: SpuriousTestable, callIdentifier: String) throws -> T {
        if let stub = findStub(target, callIdentifier: callIdentifier) {
            return stub.yield as! T
        } else {
            throw SpuriousError.NoStub
        }
    }
    
    public func didCall(target: SpuriousTestable, callIdentifier: String) -> Bool {
        return findCall(target, callIdentifier: callIdentifier) != nil
    }
    
}

extension Spurious {
    
    public func findStub(target: SpuriousTestable, callIdentifier: String) -> SpuriousStub? {
        let index = stubs.indexOf { (stub) -> Bool in
            stub.target === target && stub.callIdentifier == callIdentifier
        }
        return stubs[index!]
    }
    
    public func findCall(target: SpuriousTestable, callIdentifier: String) -> SpuriousCall? {
        let index = calls.indexOf { (call) -> Bool in
            call.target === target && call.callIdentifier == callIdentifier
        }
        return calls[index!]
    }
    
}

public class SpuriousCall {
    let target: SpuriousTestable
    let callIdentifier: String
    
    init(_ target: SpuriousTestable, callIdentifier: String) {
        self.callIdentifier = callIdentifier
        self.target = target
    }
}

public class SpuriousStub {
    let target: SpuriousTestable
    let callIdentifier: String
    let yield: AnyObject
    
    init(_ target: SpuriousTestable, callIdentifier: String, yield: AnyObject) {
        self.target = target
        self.callIdentifier = callIdentifier
        self.yield = yield
    }
}

enum SpuriousError: ErrorType {
    case NoStub
}

public protocol SpuriousTestable : class {
    var spurious: Spurious { get }
    
    func callSpurious(callIdentifier: String)
    func callSpurious<T>(callIdentifier: String) -> T
    func stub(callIdentifier: String, yield: AnyObject)
    
    func wasCalled(callIdentifier: String) -> Bool
}

extension SpuriousTestable {
    var spurious: Spurious {
        get {
            return Spurious.sharedInstance
        }
    }
    
    func callSpurious(callIdentifier: String = __FUNCTION__) {
        spurious.called(self, callIdentifier: callIdentifier)
    }
    
    func callSpurious<T>(callIdentifier: String = __FUNCTION__) -> T {
        spurious.called(self, callIdentifier: callIdentifier)
        return try! spurious.yield(self, callIdentifier: callIdentifier)
    }
    
    func stub(callIdentifier: String, yield: AnyObject) {
        spurious.stub(self, callIdentifier: callIdentifier, yield: yield)
    }
    
    func wasCalled(callIdentifier: String) -> Bool {
        return spurious.didCall(self, callIdentifier: callIdentifier)
    }
}