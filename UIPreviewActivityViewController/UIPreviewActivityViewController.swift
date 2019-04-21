
import UIKit
import QuickLook

public final class UIPreviewActivityViewController: UIActivityViewController {
    
    /// The preview container view
    private lazy var preview: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    private lazy var quicklook = QLPreviewController.init()
    
    /// Internal storage of the activity items
    private let activityItems: [Any]

    // MARK: - Configuration
    
    /// The duration for the preview fading in
    var fadeInDuration: TimeInterval = 0.3
    
    /// The duration for the preview fading out
    var fadeOutDuration: TimeInterval = 0.3
    
    /// The corner radius of the preview
    var previewCornerRadius: CGFloat = 12
    
    /// The corner radius of the preview image
    var previewImageCornerRadius: CGFloat = 3
    
    /// The side length of the preview image
    var previewImageSideLength: CGFloat = 80
    
    /// The padding around the preview
    var previewPadding: CGFloat = 12
    
    /// The margin from the top of the viewController's superview
    var previewTopMargin: CGFloat = 8
    
    /// The margin from the top of the viewController's view
    var previewBottomMargin: CGFloat = 8
    
    // MARK: - Init
    
    public convenience init(strings: String...) {
        self.init(activityItems: strings, applicationActivities: nil)
    }
    
    public convenience init(images: UIImage...) {
        self.init(activityItems: images, applicationActivities: nil)
    }
    
    public convenience init(urls: URL...) {
        self.init(activityItems: urls, applicationActivities: nil)
    }
    
    public convenience init(data: Data...) {
        self.init(activityItems: data, applicationActivities: nil)
    }
    
    public override init(activityItems: [Any], applicationActivities: [UIActivity]? = nil) {
        self.activityItems = activityItems
        super.init(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    
    // MARK: - View Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        preview.translatesAutoresizingMaskIntoConstraints = false
        preview.layer.cornerRadius = previewCornerRadius
        preview.clipsToBounds = true
        preview.alpha = 0

        quicklook.loadViewIfNeeded()
        preview.contentView.addSubview(quicklook.view)
        
        for index in 0..<activityItems.count {
            let url: String
            let item = activityItems[index]
            let cache = URL.init(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0])
            if let i = item as? URL {
                if i.isFileURL {
                    url = i.path
                } else {
                    let u = cache.appendingPathComponent("\(index).txt")
                    do {
                        try i.absoluteString.write(to: u, atomically: true, encoding: .utf8)
                    } catch {
                        // ...
                    }
                    url = u.path
                }
            } else if let i = item as? UIImage {
                let u = cache.appendingPathComponent("\(index).png")
                do {
                    try i.pngData()?.write(to: u)
                } catch {
                    // ...
                }
                url = u.path
            } else if let i = item as? Data {
                let u = cache.appendingPathComponent("\(index).data")
                do {
                    try i.write(to: u)
                } catch {
                    // ...
                }
                url = u.path
            } else if let i = item as? String {
                let u = cache.appendingPathComponent("\(index).txt")
                do {
                    try i.write(to: u, atomically: true, encoding: .utf8)
                } catch {
                    // ...
                }
                url = u.path
            } else {
                let s = String.init(describing: item)
                let u = cache.appendingPathComponent("\(index).txt")
                do {
                    try s.write(to: u, atomically: true, encoding: .utf8)
                } catch {
                    //            fatalError()
                }
                url = u.path
            }
            urls.append(NSURL.init(fileURLWithPath: url))
        }
        
        quicklook.delegate = self
        quicklook.dataSource = self
        
        self.present(quicklook, animated: false) {
            self.preview.contentView.addSubview(self.quicklook.view)
        }
    }
    
    var urls: [NSURL] = []
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let superview = view.superview else {
            return
        }
        
        superview.addSubview(preview)
        
        let topAnchor: NSLayoutYAxisAnchor
        if #available(iOS 11.0, *) {
            topAnchor = superview.safeAreaLayoutGuide.topAnchor
        }
        else {
            topAnchor = superview.topAnchor
        }
        
        NSLayoutConstraint.activate([
            preview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            preview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            preview.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -previewBottomMargin),
            preview.topAnchor.constraint(equalTo: topAnchor, constant: previewTopMargin)
            ])
        
        NSLayoutConstraint.activate([
            quicklook.view.topAnchor.constraint(equalTo: preview.topAnchor, constant: previewPadding),
            quicklook.view.bottomAnchor.constraint(equalTo: preview.bottomAnchor, constant: -previewPadding),
            quicklook.view.leadingAnchor.constraint(equalTo: preview.leadingAnchor, constant: previewPadding),
            quicklook.view.trailingAnchor.constraint(equalTo: preview.trailingAnchor, constant: -previewPadding),
            ])
        
        UIView.animate(withDuration: fadeInDuration) {
            self.preview.alpha = 1
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: fadeOutDuration) {
            self.preview.alpha = 0
        }
    }
    
}

extension UIPreviewActivityViewController: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return urls.count
    }
    
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return urls[index]
    }
    
    public func previewControllerWillDismiss(_ controller: QLPreviewController) {
        for u in urls {
            try? FileManager.default.removeItem(at: u as URL)
        }
    }
}
