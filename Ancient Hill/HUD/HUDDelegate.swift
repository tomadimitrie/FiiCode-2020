import Foundation

enum Direction: String {
    case top
    case right
    case bottom
    case left
    case action
}

protocol HUDDelegate: class {
    func hudTapped(for direction: Direction)
    func hudReleased(for direction: Direction)
}

protocol ActionButtonVisibilityDelegate: class {
    func toggleActionButton(to flag: Bool)
}
