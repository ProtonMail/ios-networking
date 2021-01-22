//
//  ContentView.swift
//  PMNetworking_SwiftUI_Example
//
//  Created by Greg on 22.01.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = NetworkingViewModel()
    
    var body: some View {
        VStack {
            Picker(selection: $viewModel.selectedIndex, label: Text("")) {
                ForEach(0..<viewModel.env.count) { index in
                    Text(viewModel.env[index]).tag(index)
                }
            }.pickerStyle(SegmentedPickerStyle()).padding()
            Button("Human Verification unauth test", action: {
                viewModel.humanVerificationUnauthAction()
            }).padding()
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
