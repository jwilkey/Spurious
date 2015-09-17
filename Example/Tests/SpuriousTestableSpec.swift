import Quick
import Nimble
import Spurious
import Spurious_Example

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

        describe("instance callSpurious") {

            var manualSpurious: ManualSpurious!

            beforeEach({
                manualSpurious = ManualSpurious()
                spuriousManager.setSpurious(manualSpurious, forIdentifier:subject.identifier)
            })

            context("with the default parameters") {
                it("records a call with spurious") {
                    subject.punch()

                    expect(manualSpurious.called.wasCalled) == true
                    expect(manualSpurious.called.identifier) == "punch()"
                    expect(manualSpurious.called.parameters.count) == 0
                }
            }

            context("with a custom call identifier") { () -> Void in
                it("records a call with spurious using the custom call identifier") {
                    subject.callSpurious("someString")

                    expect(manualSpurious.called.wasCalled) == true
                    expect(manualSpurious.called.identifier) == "someString"
                    expect(manualSpurious.called.parameters.count) == 0
                }
            }

            context("with the called parameters") { () -> Void in
                it("records a call with spurious along with the parameters") {
                    subject.callSpurious("someString", with: ["arg1", 3])

                    expect(manualSpurious.called.wasCalled) == true
                    expect(manualSpurious.called.identifier) == "someString"
                    expect(manualSpurious.called.parameters.count) == 2
                    expect(manualSpurious.called.parameters).to(contain("arg1", 3))
                }
            }
        }

        describe("instance callSpurious -> T") {

            var manualSpurious: ManualSpurious!

            beforeEach({
                manualSpurious = ManualSpurious()
                spuriousManager.setSpurious(manualSpurious, forIdentifier:subject.identifier)
            })

            context("with the default parameters") {
                it("records a call with spurious") {
                    let damage = subject.kick()

                    expect(manualSpurious.called.wasCalled) == true
                    expect(manualSpurious.called.identifier) == "kick()"
                    expect(manualSpurious.called.parameters.count) == 0
                    expect(damage) == 987
                }
            }

            context("with a custom call identifier") { () -> Void in
                it("records a call with spurious using the custom call identifier") {
                    let yield: Int = subject.callSpurious("someString")

                    expect(manualSpurious.called.wasCalled) == true
                    expect(manualSpurious.called.identifier) == "someString"
                    expect(manualSpurious.called.parameters.count) == 0
                    expect(yield) == 987
                }
            }

            context("with the called parameters") { () -> Void in
                it("records a call with spurious along with the parameters") {
                    let yield: Int = subject.callSpurious("someString", with: ["arg1", 3])

                    expect(manualSpurious.called.wasCalled) == true
                    expect(manualSpurious.called.identifier) == "someString"
                    expect(manualSpurious.called.parameters.count) == 2
                    expect(manualSpurious.called.parameters).to(contain("arg1", 3))
                    expect(yield) == 987
                }
            }
        }

        describe("wasCalled") {

            var manualSpurious: ManualSpurious!

            it("asks spurious if the given identifier was called") {
                manualSpurious = ManualSpurious()
                spuriousManager.setSpurious(manualSpurious, forIdentifier:subject.identifier)

                subject.wasCalled("someFunction")

                expect(manualSpurious.wasCalled.wasCalled) == true
                expect(manualSpurious.wasCalled.identifier) == "someFunction"
                expect(manualSpurious.wasCalled.parameters.count) == 0
            }
        }

        describe("wasCalled with:") {

            var manualSpurious: ManualSpurious!

            beforeEach({
                manualSpurious = ManualSpurious()

                spuriousManager.setSpurious(manualSpurious, forIdentifier:subject.identifier)
            })

            sharedExamples("passing along arguments", closure: {
                it("asks spurious if the given identifier was called with the correct arguments") {
                    expect(manualSpurious.wasCalled.wasCalled) == true
                    expect(manualSpurious.wasCalled.identifier) == "someFunction"
                    expect(manualSpurious.wasCalled.parameters.count) == 2
                    let arg1 = manualSpurious.wasCalled.parameters[0] as! With<String>
                    let arg2 = manualSpurious.wasCalled.parameters[1] as! With<Int>
                    expect(arg1) == with("arg1")
                    expect(arg2) == with(2)
                }
            })

            context("using with()") {
                beforeEach {
                    subject.wasCalled("someFunction", with("arg1"), with(2))
                }

                itBehavesLike("passing along arguments")
            }

            context("using and()") {
                beforeEach {
                    subject.wasCalled("someFunction", with("arg1"), and(2))
                }

                itBehavesLike("passing along arguments")
            }

            context("using <-") {
                beforeEach {
                    subject.wasCalled("someFunction", <-"arg1", <-2)
                }

                itBehavesLike("passing along arguments")
            }

            context("using variable references") {
                beforeEach {
                    let v1 = "arg1"
                    let v2 = 2
                    subject.wasCalled("someFunction", with(v1), with(v2))
                }

                itBehavesLike("passing along arguments")
            }
        }
    }
}
