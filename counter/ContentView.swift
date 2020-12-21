//
//  ContentView.swift
//  counter
//
//  Created by Coding on 12/20/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
        @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var count:Int = 0
    @State private var previousState:Int = 0
    @State private var isEditing:Bool = false
    
    @State var showInfo:Bool = false

    var body: some View {
        VStack {
            if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                Spacer()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            } else {
                Spacer()
            }
                Spacer()
            Text("\(count)")
                .font(.system(size: 100))
            Spacer()
            HStack {
                Spacer()
                if count == 0 {
                    Button(action: {
                        count -= 1
                    }, label: {
                        Image(systemName: "minus")
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 60))
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    })
                    .disabled(true)
                } else {
                    Button(action: {
                        count -= 1
                    }, label: {
                        Image(systemName: "minus")
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 60))
                            .background(Color.gray)
                            .foregroundColor(.yellow)
                            .cornerRadius(10)
                    })
                }
                Spacer()
                Button(action: {
                    count += 1
                }, label: {
                    Image(systemName: "plus")
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 60))
                        .background(Color.gray)
                        .foregroundColor(.yellow)
                        .cornerRadius(10)
                })
                Spacer()
            }
            Spacer()
            HStack {
                if count == 0 {
                    Button(action: {
                        count = previousState
                    }, label: {
                        Image(systemName: "gobackward")
                    })
                } else {
                    Button(action: {
                        previousState = count
                        count = 0
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
