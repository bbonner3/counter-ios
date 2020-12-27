//
//  ContentView.swift
//  counter
//
//  Created by Coding on 12/20/20.
//

import SwiftUI
import CoreData
import AVFoundation

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
        @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @AppStorage(wrappedValue: 9999, "limitValue") var currentLimitValue:Int
    @AppStorage(wrappedValue: 0, "resetValue") var currentResetValue:Int
    @AppStorage(wrappedValue: 0, "count") private var count:Int
    
    @State private var previousState:Int = 0
    @State var showInfo:Bool = false
    
    private let resetSound:SystemSoundID = 1102
    private let previousSound:SystemSoundID = 1075

    var body: some View {
        VStack {
            if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                Spacer()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            } else {
                Spacer()
            }
                Spacer()
            Text("\(self.count)")
                .font(.system(size: 100))
            Spacer()
            ButtonLayout(currentLimitValue: $currentLimitValue, currentResetValue: $currentResetValue, count: $count)
            Spacer()
            HStack {
                if self.count == currentResetValue {
                    Button(action: {
                        self.count = self.previousState
                        AudioServicesPlaySystemSound(previousSound)
                    }, label: {
                        Image(systemName: "gobackward")
                    })
                } else {
                    Button(action: {
                        reset()
                    }, label: {
                        Image(systemName: "multiply.circle.fill")
                    })
                }
                Spacer()
                Button(action: {
                    self.showInfo.toggle()
                }, label: {
                    Image(systemName: "info.circle.fill")
                })
                .sheet(isPresented: $showInfo, content: {
                    InfoView()
                })
            }
            .padding()
        }
    }
    
    func reset() {
        
        previousState = self.count
        self.count = currentResetValue
        if UserDefaults.standard.bool(forKey: "sound") {
            AudioServicesPlaySystemSound(resetSound)
        }
        UserDefaults.standard.set(self.count, forKey: "count")
    }
}

struct ButtonLayout:View {
    let feedback = UIImpactFeedbackGenerator()
    
    @AppStorage(wrappedValue: Layout.plusminus, "buttonLayout") var currentBtnLayout:Layout
    @AppStorage(wrappedValue: false, "isInvert") var isInvert:Bool
    
    @Binding var currentLimitValue:Int
    @Binding var currentResetValue:Int
    @Binding var count:Int
    
    private let addSound:SystemSoundID = 1103
    private let subtractSound:SystemSoundID = 1104


    var body: some View {
        HStack {
            Spacer()
            switch currentBtnLayout {
            case .minus:
                minusBtn
            case .plus:
                plusBtn
            case .plusminus:
                if isInvert {
                    plusBtn
                } else {
                    minusBtn
                }
                Spacer()
                if !isInvert {
                    plusBtn
                } else {
                    minusBtn
                }
            }
            Spacer()
        }
    }
    
    var plusBtn: some View {
        Button(action: {
            add()
        }, label: {
            Image(systemName: "plus")
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .font(.system(size: 60))
                .background(Color(.systemGray2))
                .foregroundColor(Color(self.count < currentLimitValue ? .systemYellow : .systemGray6))
                .cornerRadius(10)
        })
        .disabled(self.count == currentLimitValue)
    }
    
    var minusBtn: some View {
        Button(action: {
            subtract()
        }, label: {
            Image(systemName: "minus")
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .font(.system(size: 60))
                .background(Color(.systemGray2))
                .foregroundColor(Color(self.count > currentResetValue ? .systemYellow : .systemGray6))
                .cornerRadius(10)
        })
        .disabled(self.count == currentResetValue)
    }
    
    func add() {
        self.count += 1
        UserDefaults.standard.set(self.count, forKey: "count")
        if UserDefaults.standard.bool(forKey: "sound") {
            AudioServicesPlaySystemSound(addSound)
        }
        feedback.impactOccurred(intensity: 1)
    }
    func subtract() {
        self.count -= 1
        UserDefaults.standard.set(self.count, forKey: "count")
        UserDefaults.standard.bool(forKey: "sound") ? AudioServicesPlaySystemSound(subtractSound) : feedback.impactOccurred(intensity: 1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
