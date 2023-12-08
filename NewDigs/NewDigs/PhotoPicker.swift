//
//  PhotoPicker.swift
//  ShowMe
//
//  Created by Arthur Roolfs on 10/26/22.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
        
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        var parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
                        
            picker.dismiss(animated: true)
            
            guard let itemProvider = results.first?.itemProvider else { return }
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { img, error in
                    
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    DispatchQueue.main.async {
                        self.parent.image = img as? UIImage
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {

        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        configuration.preferredAssetRepresentationMode = .current

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
}

extension Image {
    public init(imageData: Data?, placeholder: String) {
        guard let data = imageData, let uiImage = UIImage(data: data) else {
            self.init(placeholder)
            return
        }
        self.init(uiImage: uiImage)
    }
}
