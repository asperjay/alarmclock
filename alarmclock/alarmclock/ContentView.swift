//
//  ContentView.swift
//  alarmclock
//
//  Created by Jasper Elsley on 8/3/23.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
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
        var urlComponents = URLComponents(string: "http://localhost:8001")!
        urlComponents.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }

        // Create the URL from URL components
        let url = urlComponents.url!

        // Make the request with Alamofire
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Response JSON: \(value)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
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
    func toggleListening() {
        
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
