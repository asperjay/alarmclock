//
//  ContentView.swift
//  alarmclock
//
//  Created by Jasper Elsley on 8/3/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    
    private func startRecording() {
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
        isRecording = true
    }
    
    private func stopRecording() {
        speechRecognizer.stopTranscribing()
        isRecording = false
        // put python calls here
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
