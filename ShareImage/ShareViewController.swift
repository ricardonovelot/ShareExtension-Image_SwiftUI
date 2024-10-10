//
//  ShareViewController.swift
//  ShareImage
//
//  Created by Ricardo on 08/10/24.
//

import UIKit
import Social
import UniformTypeIdentifiers
import SwiftUI

class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ensure access to extensionItem and itemProvider
        guard
            let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = extensionItem.attachments?.first else {
            close()
            return
        }
        
        // Check type identifier
        let imageDataType = UTType.image.identifier
        if itemProvider.hasItemConformingToTypeIdentifier(imageDataType) {
            printContent("data type accepted")
            // Load the item from itemProvider
                   itemProvider.loadItem(forTypeIdentifier: imageDataType , options: nil) { (providedImage, error) in
                       if let error = error {
                           print("Error loading text item: \(error.localizedDescription)")
                           self.close()
                           return
                       }

                       
                       if let image = providedImage as? UIImage {
                           // if we get here, we're good and can show the View :D
                           DispatchQueue.main.async { // y tell that we want the code responsible for showing the view to run on the main thread with DispatchQueue.main.async , because the loadItem closure can be executed on background threads.
                                               // host the SwiftU view
                                               let contentView = UIHostingController(rootView: ShareExtensionView(image: image))
                                               self.addChild(contentView)
                                               self.view.addSubview(contentView.view)
                                               
                                               // set up constraints
                                               contentView.view.translatesAutoresizingMaskIntoConstraints = false
                                               contentView.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                                               contentView.view.bottomAnchor.constraint (equalTo: self.view.bottomAnchor).isActive = true
                                               contentView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                                               contentView.view.rightAnchor.constraint (equalTo: self.view.rightAnchor).isActive = true
                                           }
                           
                       } else {
                           self.close()
                           return
                       }
                   }
            
        } else {
            close()
            return
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("close"), object: nil, queue: nil) { _ in
            DispatchQueue.main.async {
                self.close()
            }
        }
    }
    
    /// Close the Share Extension
    func close() {
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

}
