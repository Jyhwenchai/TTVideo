//
//  VideoListCell.swift
//  SixThirty (iOS)
//
//  Created by 蔡志文 on 2021/12/27.
//

import SwiftUI
import AVKit
import Kingfisher

struct PlayListCell: View {
    
    let video: Video
    
    @State private var showPlayIcon: Bool = true
    
    @ObservedObject var viewModel: PlayerViewModel
    
    var containerWidth: CGFloat
    var showSeperate: Bool
    
    var body: some View {
        
        VStack(alignment:.center) {
            HStack {
                Text(video.title)
                    .font(Font.system(size: 13))
                Spacer()
                Text(Formatter.formatDateInterval(video.publishTime))
                    .font(Font.system(size: 11))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            
            ZStack(alignment: .center) {
                if let playItem = viewModel.playItem,
                   playItem == video,
                   viewModel.isPlaying || viewModel.isPaused {
                    
                    VideoPlayer(player: viewModel.player)
                        .frame(width: containerWidth - 32, height: 200)
                        .cornerRadius(4)
                        .clipped()
                        .onAppear {
                            switchPlayIconShowState()
                        }
                        .onDisappear {
                            if let newItem = viewModel.playItem,
                               newItem == playItem {
                                viewModel.clearPlayItem()
                            }
                        }
                        .onTapGesture {
                            switchPlayIconShowState()
                        }
                    
                    Button {
                        pauseOrContinuePlayVideo()
                        switchPlayIconShowState()
                    } label: {
                        Image(systemName: viewModel.isPlaying ? "pause.circle" : "play.circle")
                            .resizable()
                            .foregroundColor(.white)
                    }
                    .frame(width: 45, height: 45)
                    .opacity(showPlayIcon ? 1.0 : 0)
                    .animation(.easeOut(duration: 0.25), value: showPlayIcon)
                    
                } else {
                    
                    KFImage(URL(string: video.cover))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: containerWidth - 32, height: 200)
                        .cornerRadius(4)
                        .clipped()
                    
                    if let playItem = viewModel.playItem,
                       playItem == video,
                       viewModel.playStatus != .noPlay  {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                    } else {
                        Button { tryPlaySelectVideo(video) } label: {
                            Image(systemName: "play.circle")
                                .resizable()
                                .foregroundColor(.white)
                        }
                        .frame(width: 45, height: 45)
                    }
                    
                }
                
            }
            
            if showSeperate {
                Rectangle()
                    .fill(Color(red: 0.95, green: 0.95, blue: 0.95))
                    .frame(width: containerWidth, height: 5)
                    .padding(.bottom, 8)
            }
        }
    }
    
    private func switchPlayIconShowState() {
        showPlayIcon = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if viewModel.isPlaying {
                self.showPlayIcon = false
            }
        }
    }
    
    private func pauseOrContinuePlayVideo() {
        if viewModel.isPaused {
            viewModel.play()
        } else {
            viewModel.pause()
        }
    }
    
    private func tryPlaySelectVideo(_ video: Video) {
        do {
            try viewModel.selectPlayItem(video)
        } catch {
            print("play video failed.")
        }
    }
}
