//
//  PhotosSelector.swift
//  PiPify
//
//  Created by Arnaud NOMMAY on 13/03/2023.
//

import SwiftUI
import PhotosUI

struct PhotosSelector: View {
    @State var image: NSImage?
    let onDroped: (NSImage) -> ()
    
    var body: some View {
        
        Text("Drag and drop an image file here.")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.2))
            .onDrop(of: ["public.file-url"], isTargeted: nil) { providers -> Bool in
                guard let provider = providers.first else { return false }
                
                provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { data, error in
                    guard let data = data as? Data,
                          let url = URL(dataRepresentation: data, relativeTo: nil),
                          let image = NSImage(contentsOf: url) else { return }
                    
                    DispatchQueue.main.async {
                        self.image = image
                        onDroped(image)
                    }
                }
                
                return true
            }
    }
}

struct PhotosSelector_Previews: PreviewProvider {
    static var previews: some View {
        PhotosSelector(image: NSImage(named: "imageTest"), onDroped: { _ in  })
    }
}
