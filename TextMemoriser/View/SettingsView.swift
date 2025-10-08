//
//  SettingsView.swift
//  TextMemoriser
//
//  Created by Cormell, David - DPC on 11/03/2024.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @EnvironmentObject var stateController: StateController
    @State private var hasDailyReminders = false
    
    var body: some View {
        Form {
            Picker(selection: $stateController.translation, label: Text("Translation:"), content: {
                ForEach(Translation.allCases, id: \.self) { translation in
                    Text(translation.details.description)
                        .tag(translation)
                }
            })
            Toggle("Daily Reminders", isOn: $hasDailyReminders)
                .onChange(of: hasDailyReminders) { _ in
                    if hasDailyReminders == true {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success { print("All set!") }
                            else if let error { print(error.localizedDescription) }
                        }
                        
                        let content = UNMutableNotificationContent()
                        content.title = "Memorise the Bible!"
                        content.subtitle = "Your Word is a lamp unto my feet and a light to my path."
                        content.sound = UNNotificationSound.default

                        // show this notification five seconds from now
                        var date = DateComponents()
                        date.hour = 8
                        date.minute = 30
                        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

                        // choose a random identifier
                        let request = UNNotificationRequest(identifier: "daily", content: content, trigger: trigger)

                        // add our notification request
                        UNUserNotificationCenter.current().add(request)
                        print("Got here")
                        
                    } else {
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily"])
                    }
                }
        }
    }
}

#Preview {
    SettingsView().environmentObject(StateController())
}
