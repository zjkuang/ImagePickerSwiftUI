//
//  ImagePickerView.swift
//  ImagePickerSwiftUI
//
//  Created by Zhengqian Kuang on 2019-09-24.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import SwiftUI

struct ImagePickerController: UIViewControllerRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = context.coordinator
        return imagePickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        //
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerController
        
        init(_ imagePickerController: ImagePickerController) {
            self.parent = imagePickerController
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                // let imageOrientation = uiImage.imageOrientation // photos taken by camera usually do not have a correct imageOrientation
                if let uiImageAdjusted = uiImage.upOrientationImage() {
                    let image = Image(uiImage: uiImageAdjusted)
                    NotificationCenter.default.post(name: .imagePickerDidPickImage, object: image)
                }
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
}
