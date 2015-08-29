import UIKit

class ViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        answerLoader = SlowApiAnswerLoader()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        answerLoader = SlowApiAnswerLoader()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadTheAnswer()
    }

    @IBOutlet weak var answerLabel: UILabel!
    
    var answerLoader: AnswerLoader
    
    private func loadTheAnswer() {
        answerLabel.text = answerLoader.fetchTheAnswer()
    }
}

class SlowApiAnswerLoader: AnswerLoader {
    func fetchTheAnswer() -> String {
        return "because sometimes the real thing is just too risky."
    }
}