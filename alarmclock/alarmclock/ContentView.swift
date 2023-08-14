//
//  ContentView.swift
//  alarmclock
//
//  Created by Jasper Elsley on 8/3/23.
//

import SwiftUI
import Alamofire
import Foundation

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
        var urlComponents = URLComponents(string: "http://localhost:8001")!
        urlComponents.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }

        // Create the URL from URL components
        let url = urlComponents.url!

        // Make the request with Alamofire
        /* AF.request(url).responseDecodable(of: [String: String].self) { response in
            switch response.result {
            case .success(let value):
                print("Response JSON: \(value)")
            case .failure(let error):
                print("Error: \(error)")
            }
        } */
        
        // setup date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // extract json values
        fetchData(from: "your_api_endpoint_here") { responseValue, timesValue, error in
            if let responseValue = responseValue, let timesValue = timesValue {
                self.timesValue = timesValue // Store the timesValue in the view's state
                parseJSON(responseValue: responseValue, timesValue: timesValue)
            } else if let error = error {
                print("Error: \(error)")
            }
        }
        print(formattedDate)
        
    }
    var formattedDate: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if let date = dateFormatter.date(from: timesValue) {
                let formattedDateString = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)
                return formattedDateString
            } else {
                return "Invalid Date"
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
func fetchData(from url: String, completion: @escaping (String?, String?, Error?) -> Void) {
    AF.request(url).responseDecodable(of: [String: String].self) { response in
        switch response.result {
        case .success(let value):
            let responseValue = value["response"]
            let timesValue = value["times"]
            completion(responseValue, timesValue, nil)
        case .failure(let error):
            completion(nil, nil, error)
        }
    }
}
func parseJSON(responseValue: String?, timesValue: String?) {
    if let responseValue = responseValue, let timesValue = timesValue {
        if let jsonData = responseValue.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? NSDictionary {
                    // Use responseValue and timesValue here
                    if let jsonResponseValue = json["response"] as? String,
                       let jsonTimesValue = json["times"] as? String {
                        // Use jsonResponseValue and jsonTimesValue
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
