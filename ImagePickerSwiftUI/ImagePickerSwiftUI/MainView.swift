//
//  MainView.swift
//  ImagePickerSwiftUI
//
//  Created by Zhengqian Kuang on 2019-09-24.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject private var imagePickerViewModel = ImagePickerViewModel()
    @State private var presentSheet = false
    
    var body: some View {
        NavigationView {
            Group {
                VStack {
                    (imagePickerViewModel.image as? Image)?
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Button((imagePickerViewModel.image == nil) ? "Take a picture" : "Re-take") {
                        self.presentSheet.toggle()
                    }
                }
                .padding()
            }
            .navigationBarTitle("ImagePicker Example")
            .navigationBarItems(trailing: trailingItems)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $presentSheet) {
            ImagePickerController()
        }
    }
    
    private var trailingItems: some View {
        Button("Clear") {
            self.imagePickerViewModel.image = nil
        }
    }
    
}
