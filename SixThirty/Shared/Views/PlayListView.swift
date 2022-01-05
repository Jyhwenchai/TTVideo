//
//  PlayListView.swift
//  SixThirty (iOS)
//
//  Created by 蔡志文 on 2021/12/24.
//

import SwiftUI

struct PlayListView: View {
    
    @StateObject private var viewModel: PlayerViewModel = PlayerViewModel()
    @State private var showFilterOverlay: Bool = false
    @State private var selectDate: Date = Date()
    @State @MainActor private var viewFirstAppear: Bool = true
    
    private var selecteTimeInterval: Int64 {
        Int64(selectDate.timeIntervalSince1970 * 1000)
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    List(viewModel.videoList.videos.indices, id: \.self) { index in
                        let video = viewModel.videoList.videos[index]
                        PlayListCell(video: video, viewModel: viewModel, containerWidth: geometry.size.width, showSeperate: !shouldLoadMore(at: index))
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.white)
                            .onAppear {
                                if shouldLoadMore(at: index) && viewModel.hasMore {
                                    Task {
                                        await fetchData(with: viewModel.maxBehotTime, reload: false)
                                    }
                                }
                            }
                        
                        if viewModel.isLoading && shouldLoadMore(at: index) {
                            ProgressView("loading...")
                                .progressViewStyle(.circular)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .navigationTitle("Video List")
                    .navigationBar(showOverlay: $showFilterOverlay)
                    .listStyle(.plain)
                    .buttonStyle(PlainButtonStyle())
                    .refreshable {
                        selectDate = Date()
                        await fetchData(with: selecteTimeInterval)
                    }
                    
                    if showFilterOverlay {
                        PlayListFilterView(selectDate: $selectDate, show: $showFilterOverlay) {
                            await fetchData(with: selecteTimeInterval)
                        }
                    }
                    
                    if viewFirstAppear {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
                            .offset(x: 0, y: -100)
                    }
                }
                
            }
        }
        .navigationViewStyle(.stack)
        .task {
            await fetchData(with: selecteTimeInterval)
            viewFirstAppear = false
        }
    }
    
    private func shouldLoadMore(at index: Int) -> Bool {
        return viewModel.videoList.videos.count - 1 == index
    }
    
    private func fetchData(with timeInterval: Int64, reload: Bool = true) async {
        do {
            try await viewModel.fetchVideos(by: timeInterval, reload: reload)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}



struct PlayListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayListView()
    }
}



private extension View {
    func navigationBar(showOverlay: Binding<Bool>) -> some View {
        modifier(PlayListNavigationBar(showOverlay: showOverlay))
    }
}
