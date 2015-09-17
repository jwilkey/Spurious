import Spurious

public class ManualSpurious: SpuriousType, SpuriousTestable {

    public init() {}

    public struct Call {
        public var wasCalled = false
        public var identifier = "chaos"
        public var parameters = [AnyObject]()
    }

    public struct CallExpectation {
        public var wasCalled = false
        public var identifier = "chaos"
        public var parameters = [SpuriousArgumentExpectation]()
    }

    public var called = Call()
    public var wasCalled = CallExpectation()
    public var yield = Call()

    public func called(callIdentifier: String, _ parameters: [AnyObject]) {
        called.wasCalled = true
        called.identifier = callIdentifier
        called.parameters = parameters
    }

    public func stub(callIdentifier: String, yield: AnyObject) { }

    public func yield<T>(callIdentifier: String) throws -> T {
        yield.wasCalled = true
        yield.identifier = callIdentifier
        return 987 as! T
    }

    public func wasCalled(callIdentifier: String, with: [SpuriousArgumentExpectation]) -> Bool {
        wasCalled.wasCalled = true
        wasCalled.identifier = callIdentifier
        wasCalled.parameters = with
        return false
    }
}
