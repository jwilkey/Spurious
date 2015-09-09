import Foundation

public protocol SpuriousTestable : class {

    var spurious: SpuriousType { get set }
    var identifier: ObjectIdentifier { get }

    func callSpurious(callIdentifier: String, with: [AnyObject])
    func callSpurious<T>(callIdentifier: String, with: [AnyObject]) -> T
    func stub(callIdentifier: String, yield: AnyObject)

    func wasCalled(callIdentifier: String, _ parameters: SpuriousArgumentExpectation...) -> Bool

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

    func callSpurious(callIdentifier: String = __FUNCTION__, with parameters: [AnyObject] = []) {
        spurious.called(callIdentifier, parameters)
    }

    func callSpurious<T>(callIdentifier: String = __FUNCTION__, with parameters: [AnyObject] = []) -> T {
        spurious.called(callIdentifier, parameters)
        return try! spurious.yield(callIdentifier)
    }

    func stub(callIdentifier: String, yield: AnyObject) {
        spurious.stub(callIdentifier, yield: yield)
    }

    func wasCalled(callIdentifier: String, _ parameters: SpuriousArgumentExpectation...) -> Bool {
        return spurious.wasCalled(callIdentifier, with: parameters)
    }

    func cleanup() {
        SpuriousManager.sharedInstance.removeSpuriousForIdentifier(ObjectIdentifier(self))
    }

}
