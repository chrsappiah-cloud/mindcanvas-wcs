import SwiftUI
import AVKit

struct MediaPlayerView: View {
    let mediaItem: MediaItem
    @State private var player = AVPlayer()
    @State private var isPlaying = false
    @State private var playerItem: AVPlayerItem?
    
    var body: some View {
        VStack {
            VideoPlayer(player: player)
                .frame(height: 300)
            HStack {
                Button("Play/Pause") { togglePlayback() }
                Button("Loop") { player.isLooping.toggle() }  // Custom extension
            }
            Text(mediaItem.title)
        }
        .onAppear {
            guard let url = Bundle.main.url(forResource: mediaItem.title, withExtension: "mp4") ?? mediaItem.url else { return }
            playerItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: playerItem)
        }
    }
    
    func togglePlayback() {
        isPlaying ? player.pause() : player.play()
        isPlaying.toggle()
    }
}
