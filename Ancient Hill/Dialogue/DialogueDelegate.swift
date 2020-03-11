import UIKit

struct DialogueText {
    var text: String
    var name: AtlasName
}

protocol DialogueDelegate: class {
    func toggleDialogue(to flag: Bool)
    func changeTexts(to texts: [DialogueText])
}
