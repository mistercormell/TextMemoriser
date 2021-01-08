//
//  GuessLocationView.swift
//  TextMemoriser
//
//  Created by David Cormell on 03/01/2021.
//

import SwiftUI

struct GuessLocationView: View {
    @StateObject var vm = GuessLocationViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if let reference = vm.currentReference {
                    Text(reference.text)
                            .padding()
                }
                Form {
                    Picker(selection: $vm.selectedBook, label: Text("Book"), content: {
                        ForEach(0 ..< vm.books.count) {
                            Text(vm.books[$0])
                        }
                    })
                    Picker(selection: $vm.chapter, label: Text("Chapter"), content: {
                        ForEach(0 ... 150, id: \.self) {
                            Text("\($0)")
                        }
                    })
                    Picker(selection: $vm.verse, label: Text("Verse"), content: {
                        ForEach(0 ... 60, id: \.self) {
                            Text("\($0)")
                        }
                    })
                }
                Button("Check Answer", action: {
                    if let correctReference = vm.currentReference {
                        if vm.books[vm.selectedBook] == correctReference.book && vm.chapter == correctReference.chapter && vm.verse == correctReference.verse {
                            vm.alertTitle = "Correct"
                            vm.score += 1
                        } else {
                            vm.alertTitle = "Wrong!"
                        }
                        vm.showingScore = true
                        vm.loadReference()
                    }

                })
            }
            .navigationBarTitle("Guess the Location")
            .alert(isPresented: $vm.showingScore, content: {
                Alert(title: Text("\(vm.alertTitle)"), message: Text("Your score is: \(vm.score)"), dismissButton: .default(Text("OK")))
            })
        }.onAppear(perform: {
            vm.loadReference()
        })
            

    }
}

struct GuessLocationView_Previews: PreviewProvider {
    static var previews: some View {
        GuessLocationView()
    }
}
