import Quick
import Nimble
import Spurious
import Spurious_Example

class FakeAnswerLoader: AnswerLoader, SpuriousTestable {
    
    func fetchTheAnswer() -> String {
        return callSpurious() // will register a stub identified by String "fetchTheAnswer()"
    }
    
}

class DemonstrateSpurious: QuickSpec {
    override func spec() {
        describe("Demonstrating Spurious with the Example project") {
            
            var viewController: ViewController!
            let fakeAnswerLoader: FakeAnswerLoader = FakeAnswerLoader()
            
            beforeEach({ () -> () in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                viewController = storyboard.instantiateViewControllerWithIdentifier(
                        "ViewController") as! ViewController
                
                // trigger certain view controller lifecycle events
                let _  = viewController.view
            })

            context("with the view controllers default answer loader", { () -> Void in
                it("displays the real text") {
                    viewController.viewDidAppear(true)
                    expect(viewController.answerLabel.text) == "because sometimes the real thing is just too risky."
                    
                    viewController.answerLoader = fakeAnswerLoader
                }
            })
            
            context("with a fake for the view controllers answer loader", { () -> Void in
                it("displays the stubbed text") {
                    viewController.answerLoader = fakeAnswerLoader
                    fakeAnswerLoader.stub("fetchTheAnswer()", yield: "you know where I got these stubs?")
                    
                    viewController.viewDidAppear(true)
                    expect(viewController.answerLabel.text) == "you know where I got these stubs?"
                    
                    expect(fakeAnswerLoader.wasCalled("fetchTheAnswer()")).to(beTruthy())
                }
            })
        }
    }
}
