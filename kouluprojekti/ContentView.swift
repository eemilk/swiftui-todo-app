//
//  ContentView.swift
//  kouluprojekti
//
//  Created by Eemil Karvonen on 10.10.2020.
//

import SwiftUI


struct ContentView: View {
    class TodoList: ObservableObject {
        public var listOfTodos: Array<String> = [] as Array<String>
        
        init() {
        }
        
        func addItem(newItem: String)  {
            self.listOfTodos.append(newItem)
        }
        
        func getTodoList() -> Array<String> {
            return self.listOfTodos
        }
    }

    @ObservedObject var myTodoList = TodoList()
    
    
    @State private var showingAddTodoView: Bool = false
    
    
    var body: some View {
        NavigationView {
            List(0 ..< myTodoList.getTodoList().count) { item in
                Text(myTodoList.getTodoList()[item])
            }
            .navigationBarTitle("TODO", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        self.showingAddTodoView.toggle()
                                    }) {
                                    Image(systemName: "plus")
                                    }
                .sheet(isPresented: $showingAddTodoView) {
                    AddTodoView()
                        .environmentObject(self.myTodoList)
                }
            )
        }
    }
    
    struct AddTodoView: View {
        
        @Environment(\.presentationMode) var presentationMode
        
        @EnvironmentObject var myTodoList: TodoList
        
        @State private var name: String = ""
        @State private var priority: String = "Normal"
        
        let priorities = ["High", "Normal", "Low"]
        
        var body: some View {
            NavigationView {
                VStack {
                    Form {
                        TextField("Todo", text: $name)
                        
                        Picker("Priority", selection: $priority) {
                            ForEach(priorities, id: \.self) {
                                Text($0)
                            }
                        }
                    .pickerStyle(SegmentedPickerStyle())
                        Button(action: {
                            print(name)
                            myTodoList.addItem(newItem: name)
                            
                        }) {
                            Text("Save")
                        }
                    }
                    Spacer()
                }
                .navigationBarTitle("New Todo", displayMode:
                                        .inline)
                .navigationBarItems(trailing:
                                        Button(action: {
                                            self.presentationMode.wrappedValue.dismiss()
                                        }) {
                                            Image(systemName: "xmark")
                                        })
            }
        }
    }

}
/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
