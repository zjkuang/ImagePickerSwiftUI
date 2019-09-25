//
//  ImagePickerViewModel.swift
//  ImagePickerSwiftUI
//
//  Created by Zhengqian Kuang on 2019-09-24.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import Foundation

class ImagePickerViewModel: ObservableObject {
    
    @Published var image: Any?
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification), name: .imagePickerDidPickImage, object: nil)
    }
    
    @objc func didReceiveNotification(notification: Notification) {
        if let image = notification.object {
            self.image = image
        }
    }
    
    func clear() {
        image = nil
    }
    
}
