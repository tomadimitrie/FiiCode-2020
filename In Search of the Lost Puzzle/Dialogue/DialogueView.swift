import UIKit

class DialogueView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    private var texts = [String]()
    private var index = 0
    private var timer: Timer?
    private var completionHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initXib()
    }
    
    private func initXib() {
        Bundle.main.loadNibNamed("DialogueView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onBackgroundTap(recognizer:)))
        self.contentView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func onBackgroundTap(recognizer: UITapGestureRecognizer) {
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
            self.textView.text = self.texts[index]
        } else {
            if index != self.texts.count - 1 {
                self.index += 1
                self.setText(to: self.texts[self.index])
            } else {
                self.toggleDialogue(to: false)
            }
        }
    }
    
    private func setText(to text: String) {
        guard text != "" else { return }
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
        self.textView.text = ""
        let characters = Array(text)
        var currentLetterIndex = 0
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            self.textView.text += String(characters[currentLetterIndex])
            currentLetterIndex += 1
            if currentLetterIndex == characters.count {
                timer.invalidate()
                self.timer = nil
            }
        }
    }
}

extension DialogueView: DialogueDelegate {
    func toggleDialogue(to flag: Bool) {
        if
            !flag,
            let timer = self.timer
        {
            timer.invalidate()
            self.timer = nil
        }
        if !flag, let completionHandler = self.completionHandler {
            completionHandler()
        }
        UIView.animate(withDuration: 0.5) {
            self.alpha = flag ? 1.0 : 0.0
        }
    }
    func changeTexts(to texts: [String]) {
        self.texts = texts
        self.index = 0
        self.setText(to: self.texts.first!)
    }
    func changeCompletionHandler(to handler: @escaping () -> Void) {
        self.completionHandler = handler
    }
}
