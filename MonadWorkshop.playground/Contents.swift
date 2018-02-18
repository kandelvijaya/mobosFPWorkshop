import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true



let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
view.backgroundColor = .red


PlaygroundPage.current.liveView = view


view.animate(duration: 2) {
    $0.backgroundColor = .green
}.animate(with: 3) {
    $0.backgroundColor = .purple
}.execute()






