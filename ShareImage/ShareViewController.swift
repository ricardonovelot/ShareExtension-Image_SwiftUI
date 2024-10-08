import UIKit
import Social
import UniformTypeIdentifiers
import SwiftUI

class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard
            let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = extensionItem.attachments?.first else {
            close()
            return
        }
        
        // Check for image type
        if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            print("Data type accepted")
            
            itemProvider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { (providedItem, error) in
                if let error = error {
                    print("Error loading image item: \(error.localizedDescription)")
                    self.close()
                    return
                }

                if let image = providedItem as? UIImage {
                    // Handle UIImage
                    DispatchQueue.main.async {
                        self.showSwiftUIView(with: image)
                    }
                } else if let imageUrl = providedItem as? URL {
                    // Load UIImage from URL
                    if let data = try? Data(contentsOf: imageUrl), let imageFromUrl = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.showSwiftUIView(with: imageFromUrl)
                        }
                    } else {
                        self.close()
                    }
                } else {
                    self.close()
                }
            }
        } else {
            close()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("close"), object: nil, queue: nil) { _ in
            DispatchQueue.main.async {
                self.close()
            }
        }
    }
    
    /// Show the SwiftUI View using the passed image
    func showSwiftUIView(with image: UIImage) {
        let contentView = UIHostingController(rootView: ShareExtensionView(image: image))
        self.addChild(contentView)
        self.view.addSubview(contentView.view)
        
        // Set up constraints
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            contentView.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            contentView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            contentView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }

    /// Close the Share Extension
    func close() {
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
