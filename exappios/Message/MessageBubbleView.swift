import SwiftUI

struct MessageBubbleView: View {
    let message: Message
    let isLastMessage: Bool
    let isFirstMessage: Bool
    let style: ChatStyle
    
    @State private var imageData: Data? = nil
    let formatter = DateFormatterManager.shared.timeFormatterInstance()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                switch message.type {
                case .text:
                    HStack(alignment: .bottom) {
                        Text(message.content)
                            .foregroundStyle(.white)
                        
                        if style == .telegram || style == .whatsapp {
                            Text(formatter.string(from: message.scheduledTime))
                                .font(.system(size: 10))
                                .foregroundColor(Color.white.opacity(0.5))
                        }
                    }
                    .padding(.horizontal, 9)
                    .padding(.vertical, 7)
                    .background(
                        ZStack(alignment: .bottomLeading) {
                            if isLastMessage {
                                Image("bubbleTail")
                                    .foregroundStyle(style.colorPalette.chatBackgroundColor)
                                    .frame(width: 15, height: 15)
                                    .offset(x: -4, y: 3)
                            }
                            
                            if style == .telegram {
                                RoundedRectangle(cornerRadius: 0)
                                    .fill(style.colorPalette.chatBackgroundColor)
                                    .clipShape(.rect(
                                        topLeadingRadius: isFirstMessage || isLastMessage ? 15 : 7,
                                        bottomLeadingRadius: isFirstMessage || (!isFirstMessage && !isLastMessage) ? 7 : 15,
                                        bottomTrailingRadius: 15,
                                        topTrailingRadius: 15
                                    ))
                            } else {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(style.colorPalette.chatBackgroundColor)
                            }
                        }
                    )
                    
                    
                case .image:
                    if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200, maxHeight: 200)
                            .cornerRadius(18)
                    } else {
                        ProgressView()
                            .frame(width: 200, height: 200)
                    }
                }
                
                if message.premium {
                    Text("Premium")
                        .font(.caption)
                        .foregroundColor(.yellow)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, AppSettings.messagePadding)
        .onAppear {
            if message.type == .image {
                loadImage()
            }
        }
    }
    
    private func loadImage() {
        guard let urlString = message.contentUrl, let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.imageData = data
            }
        }.resume()
    }
}

