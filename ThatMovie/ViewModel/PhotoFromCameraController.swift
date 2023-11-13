//
//  ImagePicker.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 26.10.2023.
//

import Foundation
import SwiftUI
import PhotosUI

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate/*, PHPickerViewControllerDelegate*/ {
    
    
    @Binding var image: UIImage?
//    @Binding var isShown: Bool
    
    init(image: Binding<UIImage?>/*, isShown: Binding<Bool>*/) {
        _image = image
//        _isShown = isShown
    }
    
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        //        if let uiImage = info[PhpickerCont.InfoKey.originalImage] as? UIImage {
//        //            image = uiImage
//        //            isShown = false
//        //        }
//        picker.dismiss(animated: true)
//        
//        guard let provider = results.first?.itemProvider else {return}
//        
//        if provider.canLoadObject(ofClass: UIImage.self) {
//            provider.loadObject(ofClass: UIImage.self) { image, _ in
//                self.image = image as? UIImage
//                self.isShown = false
//            }
//        }
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = uiImage
//            isShown = false
        }
    }
    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        isShown = false
//    }
    
    
    
}

struct PhotoFromCameraController: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    
    @Binding var image: UIImage?
//    @Binding var isShown: Bool
//    var sourceType: ImagePickerType = .camera
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<PhotoFromCameraController>) {
        
    }
    
    func makeCoordinator() -> PhotoFromCameraController.Coordinator {
        return ImagePickerCoordinator(image: $image/*, isShown: $isShown*/)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoFromCameraController>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
}

//struct ImagePicker: UIViewControllerRepresentable {
//    typealias Coordinator = ImagePickerCoordinator
//    
//    @Binding var image: UIImage?
//    @Binding var isShown: Bool
//    
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//        var config = PHPickerConfiguration()
//        config.filter = .images
//        
//        let picker = PHPickerViewController(configuration: config)
//        return picker
//    }
//    
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
//        
//    }
//    
//    func makeCoordinator() -> ImagePicker.Coordinator {
//        return ImagePickerCoordinator(image: $image, isShown: $isShown)
//    }
    
//}


