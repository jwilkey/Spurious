import Foundation

public protocol SpuriousTestable : class {

    var spurious: SpuriousType { get set }
    var identifier: ObjectIdentifier { get }

    func callSpurious(callIdentifier: String)
    func callSpurious<T>(callIdentifier: String) -> T
    func stub(callIdentifier: String, yield: AnyObject)

    func wasCalled(callIdentifier: String) -> Bool

    func cleanup()
}


public extension SpuriousTestable {
    var spurious: SpuriousType {
        get {
            return SpuriousManager.sharedInstance.getOrCreateSpuriousForIdentifier(ObjectIdentifier(self))
        }
        set {
            SpuriousManager.sharedInstance.setSpurious(newValue, forIdentifier: ObjectIdentifier(self))
        }
    }

    var identifier: ObjectIdentifier {
        get {
            return ObjectIdentifier(self)
        }
    }

    func callSpurious(callIdentifier: String = __FUNCTION__) {
        spurious.called(callIdentifier)
    }

    func callSpurious<T>(callIdentifier: String = __FUNCTION__) -> T {
        spurious.called(callIdentifier)
        return try! spurious.yield(callIdentifier)
    }

    func stub(callIdentifier: String, yield: AnyObject) {
        spurious.stub(callIdentifier, yield: yield)
    }

    func wasCalled(callIdentifier: String) -> Bool {
        return spurious.didCall(callIdentifier)
    }

    func cleanup() {
        SpuriousManager.sharedInstance.removeSpuriousForIdentifier(ObjectIdentifier(self))
    }

    }

}
