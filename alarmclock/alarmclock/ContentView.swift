//
//  ContentView.swift
//  alarmclock
//
//  Created by Jasper Elsley on 8/3/23.
//

import SwiftUI
import Foundation

struct ServerResponse: Decodable {
    let times: [Date]
    let response: String
}
func scheduleNotification(date: Date, title: String, body: String) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = UNNotificationSound.default
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    
    let request = UNNotificationRequest(identifier: "notificationID", content: content, trigger: trigger)
    print(date)
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled successfully")
                }
            }
        } else {
            print("!!!")
        }
    }
    
}
struct ContentView: View {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    @State private var timesValue = ""
    @State private var responseValue = ""
    @State var outputText = ""
    @State var LLMresponse = ""
    
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
        var urlComponents = URLComponents(string: "http://10.0.4.72:8001")!
        urlComponents.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }

        // Create the URL from URL components
        let url = urlComponents.url!
        
        // setup date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        // extract json values
        // setup decoder
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        guard let data = try? Data(contentsOf: url) else {
            print("connection err")
            return
        }
        print(String(decoding: data, as: UTF8.self))
        do {
            let decodedServerResponse = try decoder.decode(ServerResponse.self, from: data)
            let calendar = Calendar.current
            for alarmDate in decodedServerResponse.times {
                print(alarmDate)
                print(calendar.date(byAdding: .hour, value: -7, to: alarmDate)!)
                scheduleNotification(date: calendar.date(byAdding: .hour, value: 0, to: alarmDate)!, title: "Alarm", body: "Alarm")
            }
            LLMresponse = decodedServerResponse.response
        } catch {
            print("JSON decoding error:", error.localizedDescription)
            print(error)
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
            Text(LLMresponse)
        }
        .padding(100)
    }
    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
