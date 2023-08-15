//
//  ContentView.swift
//  alarmclock
//
//  Created by Jasper Elsley on 8/3/23.
//

import SwiftUI
import Foundation

struct ServerResponse: Decodable {
    let response: String
    let times: [Date]
}
struct ContentView: View {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    @State private var timesValue = ""
    @State private var responseValue = ""
    @State var outputText = ""
    
    private func startRecording() {
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
        isRecording = true
    }
    
    private func stopRecording() {
        speechRecognizer.stopTranscribing()
        isRecording = false
        // server calls here
        let parameters: [String: Any] = [
            "q": speechRecognizer.transcript
        ]

        // Create URL components and set the base URL
        var urlComponents = URLComponents(string: "http://localhost:8000")!
        urlComponents.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }

        // Create the URL from URL components
        let url = urlComponents.url!
        
        // setup date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // extract json values
        // setup decoder
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        guard let data = try? Data(contentsOf: url) else {
            return
        }
        guard let decodedServerResponse = try? decoder.decode(ServerResponse.self, from: data) else {
            print("Cannot decode")
            return
        }
        print(decodedServerResponse.times)
        
    }
    var body: some View {
        VStack {
            Button(action: {
                if isRecording {
                    stopRecording()
                } else {
                    startRecording()
                }
            }) {
                Image(systemName: isRecording ? "mic.circle" : "mic.circle.fill")
                .resizable()
                .scaledToFit()
            }
            .controlSize(.large)
            Text(speechRecognizer.transcript)
        }
        .padding(100)
    }
    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
