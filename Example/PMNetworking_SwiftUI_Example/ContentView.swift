//
//  ContentView.swift
//  PMNetworking
//
//  Created on 22/01/2021.
//
//
//  Copyright (c) 2021 Proton Technologies AG
//
//  This file is part of ProtonMail.
//
//  ProtonMail is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  ProtonMail is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with ProtonMail.  If not, see <https://www.gnu.org/licenses/>.

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
            Button("Force Upgrade test", action: {
                viewModel.forceUpgradeAction()
            }).padding(.top)
            Button("Human Verification unauth test", action: {
                viewModel.humanVerificationUnauthAction()
            }).padding(.top)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
