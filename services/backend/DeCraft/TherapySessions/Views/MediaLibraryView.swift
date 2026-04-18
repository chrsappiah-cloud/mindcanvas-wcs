import SwiftUI
import SwiftData
import AVKit
struct MediaLibraryView: View {
    @Query private var items: [MediaItem]
    @State private var selectedItem: MediaItem?
    var body: some View {
        NavigationStack {
            List(items) { item in
                Button {
                    selectedItem = item
                } label: {
                    HStack {
                        Image(systemName: item.mediaType.icon)
                        VStack(alignment: .leading) {
                            Text(item.title)
                            Text(item.category).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Media")
            .sheet(item: $selectedItem) { item in
                MediaPlayerView(item: item)
            }
        }
    }
}
struct MediaPlayerView: View {
    let item: MediaItem
    @State private var player = AVPlayer()
    var body: some View {
        VStack(spacing: 16) {
            if item.mediaType == .video {
                VideoPlayer(player: player)
                    .frame(height: 280)
            } else {
                Image(systemName: item.mediaType.icon)
                    .font(.system(size: 64))
                    .frame(height: 280)
            }
            HStack {
                Button("Play") { player.play() }
                Button("Pause") { player.pause() }
            }
        }
        .padding()
        .onAppear {
            if let url = item.fileURL {
                player = AVPlayer(url: url)
            }
        }
    }
}
                Text(item.title)
                    .font(.headline)
                Text(item.category)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Label("\(Int(item.duration / 60)):\(String(format: "%02d", Int(item.duration.truncatingRemainder(dividingBy: 60))))", systemImage: "clock")
                .font(.caption)
        }
    }
}

struct MediaPlayerSheet: View {
    let item: MediaItem
    @Binding var player: AVPlayer
    @Binding var isPlaying: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var playerItem: AVPlayerItem?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if item.mediaType == .video {
                    VideoPlayer(player: player)
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                } else {
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .frame(height: 250)
                        .overlay {
                            Image(systemName: item.mediaType == .audio ? "waveform" : "photo")
                                .font(.system(size: 60))
                                .foregroundStyle(.secondary)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                
                Text(item.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(item.category)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 30) {
                    Button(systemName: "backward.fill") { seekBackward() }
                    Button(isPlaying ? "pause.fill" : "play.fill") { togglePlayback() }
                        .font(.title)
                    Button(systemName: "forward.fill") { seekForward() }
                }
                .font(.title2)
                
                if item.mediaType != .image {
                    ProgressView(value: playerItem?.time ?? .zero, total: playerItem?.duration ?? 1)
                        .frame(height: 8)
                }
            }
            .padding()
            .navigationTitle("Playing")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                setupPlayer()
            }
            .onDisappear {
                player.pause()
            }
        }
    }
    
    private func setupPlayer() {
        guard let url = item.fileURL ?? Bundle.main.url(forResource: item.title, withExtension: item.mediaType.rawValue == "Video" ? "mp4" : "mp3") else { return }
        
        playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        isPlaying = true
    }
    
    private func togglePlayback() {
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }
    
    private func seekBackward() {
        let tenSeconds = CMTime(seconds: 10, preferredTimescale: 1)
        let newTime = max(0, (playerItem?.currentTime() ?? .zero) - tenSeconds)
        player.seek(to: newTime)
    }
    
    private func seekForward() {
        let tenSeconds = CMTime(seconds: 10, preferredTimescale: 1)
        let newTime = (playerItem?.currentTime() ?? .zero) + tenSeconds
        player.seek(to: newTime)
    }
}
