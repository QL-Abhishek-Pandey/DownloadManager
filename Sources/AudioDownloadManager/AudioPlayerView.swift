//
//  SwiftUIView.swift
//  
//
//  Created by Abhishek Pandey on 30/08/23.
//

import SwiftUI

public struct AudioPlayerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var player = PlayerManager()
    public var mediaUrl = ""
    public var body: some View {
        GeometryReader {_ in
            VStack {
                HStack{
                    Button {
                        
                    } label: {
                        Image("back")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                    }
                    Spacer()
                }
                Image("playerImage")
                    .resizable()
                    .frame(height: 400)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                Button {
                    
                } label: {
                    Image(player.isPlay ? "pause": "play")
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                }.padding(.top, 40)
                
            }
        }
        .onAppear {
            player.playMedia(with: mediaUrl)
        }
        
    }
}


