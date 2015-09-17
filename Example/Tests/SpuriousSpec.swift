import Quick
import Nimble
import Spurious
import Spurious_Example

class MockLogger: SpuriousLoggerType {
    var message: String = "no failure"

    func logFailureDetail(detail: String) {
        message = detail
    }
}

class SpuriousSpec: QuickSpec {
    override func spec() {
        var subject: Spurious!
        var logger: MockLogger!

        beforeEach {
            subject = Spurious()
            logger = MockLogger()
            subject.logger = logger
        }

        describe("wasCalled") {
            it("returns false if there were no calls") {
                let wasCalled = subject.wasCalled("someFunction", with: [with("hello"), with(77)])

                expect(wasCalled) == false
                expect(logger.message) == "<Spurious> There have been no recorded calls"
            }

            it("returns false if there is no call with a matching call identifier") {
                subject.calls.append(SpuriousCall(callIdentifier: "notTheOne", parameters: []))

                let wasCalled = subject.wasCalled("someFunction", with: [with("hello"), with(77)])

                expect(wasCalled) == false
                expect(logger.message) == "<Spurious> No calls identified by 'someFunction'. Received calls:\n\(subject.calls)"
            }

            context("when the identifier matches") {
                var callWithIdentifier: SpuriousCall!
                var wasCalled: Bool!

                beforeEach {
                    wasCalled = false
                    callWithIdentifier = SpuriousCall(callIdentifier: "theFunction", parameters: ["one", 2])
                    subject.calls.append(callWithIdentifier)
                    subject.calls.append(SpuriousCall(callIdentifier: "anotherFunction", parameters: ["hello", 77]))
                }

                sharedExamples("mismatch parameters", closure: {
                    it("returns false") {
                        expect(wasCalled) == false
                        expect(logger.message) == "<Spurious> No calls with matching parameters for identifier 'theFunction'. Received calls:\n\([callWithIdentifier])"
                    }
                })

                context("when there are no parameters") {
                    beforeEach {
                        wasCalled = subject.wasCalled("theFunction", with: [])
                    }

                    itBehavesLike("mismatch parameters")
                }

                context("for parameters of correct count, but wrong value") {
                    beforeEach {
                        wasCalled = subject.wasCalled("theFunction", with: [with("hello"), with(77)])
                    }

                    itBehavesLike("mismatch parameters")
                }

                context("for missing a parameter") {
                    beforeEach {
                        wasCalled = subject.wasCalled("theFunction", with: [with("one")])
                    }

                    itBehavesLike("mismatch parameters")
                }

                context("for having an extra parameter") {
                    beforeEach {
                        wasCalled = subject.wasCalled("theFunction", with: [with("one"), with(2), with("extra-param")])
                    }

                    itBehavesLike("mismatch parameters")
                }

                context("for correct parameters in wrong order") {
                    beforeEach {
                        wasCalled = subject.wasCalled("theFunction", with: [with(2), with("one")])
                    }

                    itBehavesLike("mismatch parameters")
                }
            }

            it("returns true if the identifier and parameters match") {
                subject.calls.append(SpuriousCall(callIdentifier: "theFunction", parameters: ["one", 2]))

                let wasCalled = subject.wasCalled("theFunction", with: [with("one"), with(2)])

                expect(wasCalled) == true
                expect(logger.message) == "no failure"
            }

            it("is a test for figuring out generics and types") {
                let val = "hello"
                let s = FakeSuperHero()
                s.wasCalled("something", with("hello"), and(3), and(val))
            }
        }

    }
}
