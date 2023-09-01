//
//  SwiftUIView.swift
//  
//
//  Created by Abhishek Pandey on 30/08/23.
//

import SwiftUI

public struct AudioPlayerView: View {
    
    //MARK: - Properties
    @StateObject var player = PlayerManager()
    public var mediaUrl = ""
    
    //MARK: - body
    public var body: some View {
        GeometryReader {_ in
            VStack {
                BackButtonView()
                
                Image(kAudioplayerImage)
                    .resizable()
                    .frame(height: kFourHundred * screenWidthFactor)
                    .cornerRadius(10)
                    .padding(.horizontal, 20).padding(.top, 20)
                HStack{
                    VStack(alignment: .leading) {
                        let fileName = mediaUrl.components(separatedBy: "/")
                        Text(fileName.last ?? "").padding(.vertical, 5)
                        Text("\(player.currentDuration) / \(player.totalDuration)")
                    }
                    Spacer()
                }.padding(.vertical, 20).padding(.horizontal,20)
                Button {
                    if player.isPlay {
                        player.pauseMedia()
                    } else {
                        player.resumeMedia()
                    }
                } label: {
                    Image(player.isPlay ? kPause: kPlay)
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                }.padding(.top, 40 )
                
            }
        }.navigationBarBackButtonHidden(true)
            .onAppear {
                player.playMedia(with: mediaUrl)
            }
        
    }
}


