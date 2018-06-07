
import UIKit
import UIPreviewActivityViewController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let string = "Lorem ipsum dolor sit amet, usu an fugit expetendis referrentur. Assum fuisset volumus duo te, ei ubique inimicus eum, nostrum mandamus mel in. Platonem quaerendum comprehensam et nam, at per exerci aliquip persius."
        
        let url = URL.init(string: "https://meniny.cn/")!
        
        let shareControler = UIPreviewActivityViewController.init(activityItems: [string, #imageLiteral(resourceName: "pic1"), #imageLiteral(resourceName: "pic2"), url, #imageLiteral(resourceName: "pic3"), #imageLiteral(resourceName: "pic4"), #imageLiteral(resourceName: "pic5")])
        share(shareControler, from: self.view)
    }
    
    private func share(_ vc: UIPreviewActivityViewController, from view: UIView) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            vc.popoverPresentationController?.sourceView = view
            vc.popoverPresentationController?.sourceRect = view.bounds
            vc.popoverPresentationController?.permittedArrowDirections = [.right, .left]
        }
        
        present(vc, animated: true, completion: nil)
    }

}

