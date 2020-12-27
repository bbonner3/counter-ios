//
//  InfoView.swift
//  counter
//
//  Created by Coding on 12/20/20.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    let notificationCenter = UNUserNotificationCenter.current()
    
    @State var notificationsIsOn = false
    @State private var isEditing:Bool = false
    
    let defaults = UserDefaults.standard
    
    @AppStorage(wrappedValue: false, "sound") var sound:Bool
    @AppStorage(wrappedValue: Layout.plusminus, "buttonLayout") var currentBtnLayout:Layout
    @AppStorage(wrappedValue: false, "isInvert") var isInvert:Bool
    @AppStorage(wrappedValue: 9999, "limitValue") var currentLimitValue:Int
    @AppStorage(wrappedValue: 0, "resetValue") var currentResetValue:Int
    
    var limitValueInput:Binding<String> {
        Binding<String>(
            get: { String(Int(currentLimitValue)) },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    currentLimitValue = value.intValue
                }
            })
    }
    
    var resetValueInput:Binding<String> {
        Binding<String>(
            get: { String(Int(currentResetValue)) },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    currentResetValue = value.intValue
                }
            })
    }
    
    
    
    var body: some View {
        let toggle = Binding<Bool> (
            get: { self.notificationsIsOn },
            set: { newValue in
                self.notificationsIsOn = newValue
                notificationCenter.requestAuthorization(options: [.badge, .sound]) { granted, error in
                    if let error = error {
                        return
                    }
                }
            }
        )
    
        NavigationView {
            List {
                Section(header: Text("App Settings")) {
                    Toggle(isOn: toggle, label: {
                        HStack {
                            Image(systemName: "app.badge")
                            Text("Badges")
                        }
                    })
                    Toggle(isOn: $sound, label: {
                        HStack {
                            Image(systemName: sound ? "speaker.wave.3" : "speaker.slash")
                            Text("Sound")
                        }
                    })
                    
                }
                Section(header: Text("Counter Settings")) {
                    Picker("Button Option", selection: self.$currentBtnLayout) {
                        Image(systemName: "minus.square.fill").tag(Layout.minus)
                        Image(systemName: "plusminus").tag(Layout.plusminus)
                        Image(systemName: "plus.square.fill").tag(Layout.plus)
                    }.pickerStyle(SegmentedPickerStyle())
                    Toggle(isOn: $isInvert, label: {
                        HStack {
                            Image(systemName: "arrow.right.arrow.left")
                            Text("Invert")
                        }
                    })
                    SettingView(imageString: "arrow.up.to.line", title: "Limit", value: limitValueInput, isEditing: $isEditing)
                    SettingView(imageString: "multiply", title: "Reset Value", value: resetValueInput, isEditing: $isEditing)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    isEditing ?
                        Button("Save") {
                            UIApplication.shared.endEditing()
                            isEditing = false
                        } :
                        Button("Done") {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                }
            }
        }
    }
    
    func requestNotifications() {
        notificationCenter.requestAuthorization(options: [.badge]) { granted, error in
            if let error = error {
                return
            }
        }
    }
    
    
    func removeNotifications() {
        notificationCenter.requestAuthorization(options: [.badge]) { granted, error in
            if let error = error {
                return
            }
        }
    }
}

struct SettingView: View {
    var imageString:String
    @State var title:String
    @Binding var value:String
    @State var isOn = false
    @Binding var isEditing:Bool
    var body: some View {
        HStack {
            Image(systemName: imageString)
            Text(title)
            Spacer()
            TextField("", text: $value) {
                isEditing = $0
            }
                .multilineTextAlignment(.trailing)
                .keyboardType(.numberPad)
//                .frame(width: 50, height: .infinity, alignment: .trailing)
        }
    }
}

// extension for keyboard to dismiss
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
