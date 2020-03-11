import UIKit

class DialogueView: UIView {
    @IBOutlet var contentView: UIView!
    
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
        self.toggleDialogue(to: false)
    }
}

extension DialogueView: DialogueDelegate {
    func toggleDialogue(to flag: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.alpha = flag ? 1.0 : 0.0
        }
    }
}
