import UIKit

public class ViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        answerLoader = SlowApiAnswerLoader()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder aDecoder: NSCoder) {
        answerLoader = SlowApiAnswerLoader()
        super.init(coder: aDecoder)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        loadTheAnswer()
        answerLoader.sendTheResponse("a secret distress signal", count: 7)
    }

    @IBOutlet public weak var answerLabel: UILabel!

    public var answerLoader: AnswerLoader

    private func loadTheAnswer() {
        answerLabel.text = answerLoader.fetchTheAnswer()
    }
}

class SlowApiAnswerLoader: AnswerLoader {
    func fetchTheAnswer() -> String {
        return "because sometimes the real thing is just too risky."
    }

    func sendTheResponse(response: String, count: Int) {
        print("Sending '\(response)' with count: \(count)")
    }
}
