import UIKit

protocol DialogueDelegate: class {
    func toggleDialogue(to flag: Bool)
    func changeTexts(to texts: [String])
}
