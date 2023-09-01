//
//  SwiftUIView.swift
//  
//
//  Created by Abhishek Pandey on 30/08/23.
//

import SwiftUI

struct BackButtonView: View {
    @Environment(\.dismiss) public var dismiss
    var body: some View   {
        HStack{
            Button {
            } label: {
                Image(kBack)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: kTwenty * screenWidthFactor, height: kTwenty * screenWidthFactor)
                    .padding(.leading, 20)
                    .onTapGesture {
                        dismiss()
                    }
                
            }
            Spacer()
        }
    }
}

