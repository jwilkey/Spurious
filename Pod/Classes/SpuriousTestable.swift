import Foundation

public protocol SpuriousTestable : class {
    var spurious: Spurious { get }

    func callSpurious(callIdentifier: String)
    func callSpurious<T>(callIdentifier: String) -> T
    func stub(callIdentifier: String, yield: AnyObject)

    func wasCalled(callIdentifier: String) -> Bool
}

public extension SpuriousTestable {
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
