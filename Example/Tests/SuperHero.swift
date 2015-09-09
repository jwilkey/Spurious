import Spurious

public protocol SuperHero {
    typealias SuperHeroType
    static func fromChemicalExposure() -> SuperHeroType

    func punch()
    func kick() -> Int
}

public class FakeSuperHero: SuperHero, SpuriousTestable {
    static func smackDown() { }

    public init() {}

    public static func fromChemicalExposure() -> FakeSuperHero {
        return FakeSuperHero()
    }

    public func punch() { callSpurious() }

    public func kick() -> Int { return callSpurious() }
}
