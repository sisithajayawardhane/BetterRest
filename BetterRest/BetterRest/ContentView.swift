//
//  ContentView.swift
//  BetterRest
//
//  Created by mac on 2022-05-28.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    //@State private var showingAlert = false

    static var defaultWakeTime: Date {
         var components = DateComponents()
         components.hour = 7
         components.minute = 0
         return Calendar.current.date(from: components) ?? Date.now
    }
    
    var calculateBedtime:String{
        var bedTime = "all values"
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            bedTime = sleepTime.formatted(date: .omitted, time: .shortened)
            
            
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
        }
        
        return bedTime
        
        //showingAlert = true
    }
    
    var body: some View {
        //Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
           //DatePicker("Please enter a time", selection: $wakeUp, in: Date.now...)
        NavigationView {
            VStack {
                Form {
                    Section(header:Text("When do you want to wake up?")) {
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            
                            
                            
                            
                    }
                    Section(header:Text("Desired amount of sleep")) {
                        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                            
                            
                    }
                    Section(header:Text("Daily coffee intake")) {
                        //Stepper(coffeeAmount == 1 ? "1 cup":"\(coffeeAmount) cups" , value: $coffeeAmount, in: 1...20)
                        Picker("Number of cups", selection: $coffeeAmount) {
                            ForEach(0..<10){
                                Text($0,format: .number)
                            }
                        }
                    }
                }
                
                
                
                Text("Sleep time: \(calculateBedtime)")
                    .font(.largeTitle)
                    
                    
                
                
                
            }
            .navigationTitle("BetterRest")
//            .toolbar {
//                Button("Calculate", action: calculateBedtime)
//            }
//            .alert(alertTitle, isPresented: $showingAlert){
//                Button("Ok"){}
//            } message: {
//                Text(alertMessage)
//            }
            
            
        }
        
        
    }
    
//    func calculateBedtime()->String{
//        do {
//            let config = MLModelConfiguration()
//            let model = try SleepCalculator(configuration: config)
//
//            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
//            let hour = (components.hour ?? 0) * 60 * 60
//            let minute = (components.minute ?? 0) * 60
//
//            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
//
//            var sleepTime = wakeUp - prediction.actualSleep
//
//
//            alertTitle = "Your ideal bedtime is..."
//            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
//        } catch {
//            alertTitle = "Error"
//            alertMessage = "Sorry, there was a problem calculating your bedtime"
//        }
//
//        return sleepTime
//
//        //showingAlert = true
//    }
    
//    func exampleDate() {
//        let tomorrow = Date.now.addingTimeInterval(86400)
//        let range = Date.now...tomorrow
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
