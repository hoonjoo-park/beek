@objc(BeekTitleViewManager)
class BeekTitleViewManager: RCTViewManager {
    override func view() -> UIView! {
        let label = UILabel()
        label.text = "Beek!!"
        label.textAlignment = .center
        return label
    }
    
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
