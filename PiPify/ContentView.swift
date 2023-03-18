//
//  ContentView.swift
//  PiPify
//
//  Created by Arnaud NOMMAY on 13/03/2023.
//

import SwiftUI

struct ContentView: View {
    @State var isPresented = false

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            

            
            Image("imageTest").resizable()
                .frame(width: 500)

            
            Button("Pipify") {
                isPresented.toggle()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
