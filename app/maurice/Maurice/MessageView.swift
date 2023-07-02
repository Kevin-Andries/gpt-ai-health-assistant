import SwiftUI

struct MessageView: View {
    var message: Message
    @State private var isMessageVisible = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        let botBackgroundColor = Color(UIColor.systemGray6)
        let userBackgroundColorLight = Color(red: 220/255, green: 234/255, blue: 255/255)
        let userBackgroundColorDark = Color(red: 13/255, green: 109/255, blue: 252/255)
        let isAssistant = message.author == "assistant" ? true : false

        HStack {
            Spacer()
                .frame(width: isAssistant ? 10 : 50)
            Text(message.message ?? "")
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .foregroundColor(.primary)
                .background(isAssistant ? botBackgroundColor : (colorScheme == .dark ? userBackgroundColorDark : userBackgroundColorLight))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(UIColor.systemBackground), lineWidth: 1)
                )
                .multilineTextAlignment(.leading)
                .opacity(isMessageVisible ? 1 : 0)
                .offset(x: isMessageVisible ? 0 : (isAssistant ? -20 : 20))
                .animation(.spring(), value: isMessageVisible)
            Spacer()
                .frame(width: isAssistant ? 50 : 10)
        }
        .onAppear {
            withAnimation {
                isMessageVisible = true
            }
        }
    }
}
