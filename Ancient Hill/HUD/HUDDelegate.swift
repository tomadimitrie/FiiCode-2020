import Foundation

enum Direction: String {
    case top
    case right
    case bottom
    case left
    case action
    case unknown
}

protocol HUDDelegate: class {
    func hudTapped(for direction: Direction)
    func hudReleased(for direction: Direction)
}

protocol ActionButtonDelegate: class {
    func toggleActionButton(to flag: Bool)
}
