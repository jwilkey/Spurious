import Quick
import Nimble
import Spurious

protocol SuperHero {
    typealias SuperHeroType
    static func fromChemicalExposure() -> SuperHeroType
}

class FakeSuperHero: SuperHero, SpuriousTestable {
    static func smackDown() {
        callSpurious()
    }

    static func fromChemicalExposure() -> FakeSuperHero {
        return FakeSuperHero()
    }
}

class FakeSpurious: SpuriousType, SpuriousTestable {
    func called(callIdentifier: String) { callSpurious() }
    func stub(callIdentifier: String, yield: AnyObject) { callSpurious() }
    func yield<T>(callIdentifier: String) throws -> T { return callSpurious() }
    func didCall(callIdentifier: String) -> Bool { return callSpurious() }
}

class SpuriousTestableSpec: QuickSpec {
    override func spec() {

        var subject: FakeSuperHero!
        let spuriousManager = SpuriousManager.sharedInstance

        beforeEach({
            subject = FakeSuperHero()
        })

        describe("identifier") {
            it("returns ObjectIdentifier(self)") {
                let manualIdentifier = ObjectIdentifier(subject)
                expect(subject.identifier).to(equal(manualIdentifier))
            }
        }

        describe("setting the spurious instance") {
            it("registers the new instance with Spurious") {
                let customSpurious = Spurious()

                expect(spuriousManager[subject.identifier] === customSpurious).to(beFalsy())

                subject.spurious = customSpurious
                expect(spuriousManager[subject.identifier] === customSpurious).to(beTruthy())
            }
        }

        describe("cleanup") {
            it("de-registers the associated spurious instance") {
                let fakeSuperHero = FakeSuperHero()
                let fakeSuperHeroSpurious = fakeSuperHero.spurious

                expect(fakeSuperHeroSpurious).toNot(beNil())
                let managedSpurious = spuriousManager[fakeSuperHero.identifier]
                expect(managedSpurious === fakeSuperHeroSpurious).to(beTruthy())

                fakeSuperHero.cleanup()

                expect(spuriousManager[fakeSuperHero.identifier]).to(beNil())
            }
        }

    }
}
