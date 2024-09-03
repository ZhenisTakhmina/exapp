import SwiftUI

struct MessageBubbleView: View {
    let message: Message
    let isLastMessage: Bool
    let style: ChatStyle
    
    @State private var imageData: Data? = nil
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                switch message.type {
                case .text:
                    HStack (alignment: .bottom) {
                        Text(message.content)
                        
                        if style == .telegram || style == .whatsapp {
                            Text(timeFormatter.string(from: message.scheduledTime))
                                .font(.system(size: 10))
                                .foregroundColor(Color.black.opacity(0.5))
                        }
                    }
                    .padding(.horizontal, 9)
                    .padding(.vertical, 7)
                    .background(
                        AnyView(RoundedRectangle(cornerRadius: 15).fill(getBackgroundColor(for: style)))
                    )
                    
                case .image:
                    if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200, maxHeight: 200)
                            .cornerRadius(18)
                            .background(
                                isLastMessage
                                    ? AnyView(BubbleTailShape().fill(getBackgroundColor(for: style)))
                                    : AnyView(RoundedRectangle(cornerRadius: 18).fill(getBackgroundColor(for: style)))
                            )
                    } else {
                        ProgressView()
                            .frame(width: 200, height: 200)
                            .background(
                                isLastMessage
                                    ? AnyView(BubbleTailShape().fill(getBackgroundColor(for: style)))
                                    : AnyView(RoundedRectangle(cornerRadius: 18).fill(getBackgroundColor(for: style)))
                            )
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
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
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
    
    private func getBackgroundColor(for style: ChatStyle) -> Color {
        switch style {
        case .imessage:
            return Color(hex: "#E9E9EB")
        default:
            return Color.white
        }
    }
}

#Preview {
    MessageBubbleView(message: Message(id: "", text: ["en": "hello"], premium: false, scheduledTime: Date(), isDelivered: true, isInitialMessage: true, sendDay: 1, type: .text), isLastMessage: true, style: .imessage)
}
