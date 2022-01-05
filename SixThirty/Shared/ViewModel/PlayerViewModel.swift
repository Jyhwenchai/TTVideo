//
//  PlayerViewModel.swift
//  SixThirty (iOS)
//
//  Created by 蔡志文 on 2021/12/24.
//

import AVKit
import UIKit
import Combine

enum VideoPlayStatus {
    case noPlay
    case prepareToPlay
    case readyToPlay
    case playing
    case pause
}

@MainActor
class PlayerViewModel: ObservableObject {
    
    @Published var playStatus: VideoPlayStatus = .noPlay
    @Published var videoList: VideoList = VideoList()
    @Published var isLoading: Bool = false
    
    private var subscriptions = Set<AnyCancellable>()
    private var playerItemStatusSubscription: AnyCancellable?
    
    private(set) var player: AVPlayer = AVPlayer()
    private(set) var playItem: Video? = nil
    private(set) var isFirstToPlay: Bool = false
    
    private let request = PlayListRequest()
    
    var isPlaying: Bool {
        return playStatus == .playing
    }
    
    var isPaused: Bool {
        return playStatus == .pause
    }
    
    var hasMore: Bool {
        videoList.next.hasMore
    }
    
    var maxBehotTime: Int64 {
        videoList.next.maxBehotTime
    }
    

    init() {
        initPlayerObservers()
    }
    
    // MARK: Player Control
    func selectPlayItem(_ item: Video) throws {
        guard let url = URL(string: item.url) else {
            throw "Could not create the URL"
        }
        
        clearPlayItem()
        playItem = item
        let playerItem = AVPlayerItem(url: url)
        addPlayerItemObserver(playerItem)
        player.replaceCurrentItem(with: playerItem)
        isFirstToPlay = true
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func clearPlayItem() {
        player.replaceCurrentItem(with: nil)
        removePlayerItemObserver()
        playItem = nil
        playStatus = .noPlay
    }
    
    // MARK: Player & Player Item Listener
    private func initPlayerObservers() {
        player.publisher(for: \.timeControlStatus)
            .sink { [unowned self] status in
                switch status {
                case .paused:
                    if let playerItem = self.player.currentItem,
                       playerItem.status == .readyToPlay {
                        self.playStatus = .pause
                    }
                case .playing:
                    self.isFirstToPlay = false
                    self.playStatus = .playing
                case .waitingToPlayAtSpecifiedRate: break
                default: self.playStatus = .noPlay
                }
            }
            .store(in: &subscriptions)

    }
    
    private func addPlayerItemObserver(_ playerItem: AVPlayerItem) {
        playerItemStatusSubscription = playerItem.publisher(for: \.status)
            .sink { status in
                switch status {
                case .unknown:
                    self.playStatus = .prepareToPlay
                case .readyToPlay:
                    self.player.play()
                    self.playStatus = .readyToPlay
                case .failed: print("play failed")
                default: print("unknown error")
                }
            }
    }
    
    private func removePlayerItemObserver() {
        playerItemStatusSubscription?.cancel()
    }
    
    // MARK: - Network
   nonisolated func fetchVideos(by timeInterval: Int64 = 0, reload: Bool = true) async throws {
        await MainActor.run { isLoading = true }
        do {
            let (videos, next) = try await request.fetchVideos(by: timeInterval)
            await MainActor.run {
                videoList.next = next
                if reload { videoList.videos = videos }
                else { videoList.videos.append(contentsOf: videos) }
                isLoading = false
            }
        } catch {
            await MainActor.run { isLoading = false }
            throw error
        }
    }
}
