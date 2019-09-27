//
//  MainView.swift
//  ImagePickerSwiftUI
//
//  Created by Zhengqian Kuang on 2019-09-24.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import SwiftUI
import AVFoundation
import Photos

struct MainView: View {
    
    @ObservedObject private var viewModel = ImagePickerViewModel()
    @State private var showActionSheet = false
    @State private var presentSheet = false
    @State private var showAlert = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    #if targetEnvironment(simulator)
    let isSimulator = true
    #else
    let isSimulator = false
    #endif
    
    var body: some View {
        NavigationView {
            Group {
                VStack {
                    (viewModel.image as? Image)?
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Button((viewModel.image == nil) ? "Take a picture" : "Retake") {
                        self.showActionSheet.toggle()
                    }
                }
                .padding()
            }
            .navigationBarTitle("ImagePicker Example")
            .navigationBarItems(trailing: trailingItems)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .actionSheet(isPresented: $showActionSheet, content: {
            self.actionSheetView
        })
        .alert(isPresented: $showAlert, content: {
            self.alertView
        })
        .sheet(isPresented: $presentSheet) {
            ImagePickerController(sourceType: self.sourceType)
        }
    }
    
    private var trailingItems: some View {
        Button(action: {
            self.viewModel.clear()
        }) {
            Image(systemName: "trash.fill")
        }
        .disabled(viewModel.image == nil)
    }
    
    private var actionSheetView: ActionSheet {
        ActionSheet(title: Text("Source"), message: nil, buttons: [
            .cancel(Text("Cancel"), action: {
                // do nothing
            }),
            .default(Text("Camera"), action: {
                self.sourceType = .camera
                if self.isSimulator {
                    self.showAlert.toggle()
                }
                else {
                    self.checkMediaAccessAuthorization() { (authorized) in
                        if authorized {
                            self.presentSheet.toggle()
                        }
                    }
                }
            }),
            .default(Text("Photo Library"), action: {
                self.sourceType = .photoLibrary
                self.checkMediaAccessAuthorization() { (authorized) in
                    if authorized {
                        self.presentSheet.toggle()
                    }
                }
            })
        ])
    }
    
    private var alertView: Alert {
        Alert(title: Text("Camera is not supported on Simulator."))
    }
    
    private func checkMediaAccessAuthorization(completion: @escaping (Bool) -> Void) {
        switch sourceType {
        case .camera:
            let videoAuthorizationStatus  = AVCaptureDevice.authorizationStatus(for: .video)
            if videoAuthorizationStatus == .notDetermined {
                AVCaptureDevice.requestAccess(for: .video) { (granted) in
                    completion(granted)
                }
            }
            else {
                completion(videoAuthorizationStatus == .authorized)
            }
            
        case .photoLibrary:
            let photoLibraryAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
            if photoLibraryAuthorizationStatus == .notDetermined {
                PHPhotoLibrary.requestAuthorization { (status) in
                    completion(status == .authorized)
                }
            }
            else {
                completion(photoLibraryAuthorizationStatus == .authorized)
            }
            
        default:
            completion(false)
        }
    }
    
}
