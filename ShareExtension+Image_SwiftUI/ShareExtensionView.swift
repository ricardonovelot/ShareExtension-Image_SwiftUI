//
//  ShareExtensionView.swift
//  ShareImage
//
//  Created by Ricardo on 08/10/24.
//

import SwiftUI

struct ShareExtensionView: View {
    
    @State private var image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    var body: some View {
        NavigationStack{
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        }
    }
    
    
    func close() {
            NotificationCenter.default.post(name: NSNotification.Name("close"), object: nil)
        }
}

#Preview {
    var sampleImage : UIImage = UIImage(systemName: "photo") ?? UIImage()
    ShareExtensionView(image: sampleImage)
}
