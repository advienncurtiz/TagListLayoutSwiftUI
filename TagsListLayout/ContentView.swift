//
//  ContentView.swift
//  TagsListLayout
//
//  Created by AD Viennarz  on 1/9/23.
//

// https://youtu.be/_Tj6xp1DOj0
import SwiftUI

struct ContentView: View {
    
    @State private var items: [[Item]] = [
        [
     
        ]
    ]
    
    @State private var selected: [Item] = []
    
    init() {
        
    }
    
    @State private var randomItems: [String] = [
        "Lsklajdslajlawfi",
        "1",
        "Hey",
        "What is This",
        "Nice",
        "Whatda"
    ]
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Button {
                items[items.count - 1].append(Item(title: randomItems.randomElement()!))
                
            } label: {
                Text("Add")
                    .padding()
                    .background(Color.green)
            }

            
            ForEach(items.indices, id: \.self) { index in
                HStack {
                    ForEach(items[index].indices, id: \.self) { chipIndex in
                        Text(items[index][chipIndex].title)
                            .padding(16)
                            .background(Capsule().stroke(Color.black))
                            .lineLimit(1)
                            .overlay {
                                GeometryReader { reader -> Color in
                                    let maxX = reader.frame(in: .global).maxX
                                    
                                    if maxX > UIScreen.main.bounds.width - 30 && !items[index][chipIndex].isExceeded {
                                        DispatchQueue.main.async {
                                            
                                            items[index][chipIndex].isExceeded = true
                                            
                                            let lastItem = items[index][chipIndex]
                                            
                                            items.append([lastItem])
                                            items[index].remove(at: chipIndex)
                                        }
                                    }
                                    
                                    return items[index][chipIndex].isSelected ? Color.red : Color.clear
                                }
                            }
                            .onTapGesture(perform: {
                                items[index][chipIndex].isSelected = !items[index][chipIndex].isSelected
                            })
                            .clipShape(Capsule())
                        
                    }
                }
                
            }
        }
        .onChange(of: items, perform: { (newValue: [[Item]]) in
            let reduced = newValue.reduce([], +)
            let filtered = Array(reduced).filter { $0.isSelected }
            print(filtered)
            
            self.selected = filtered
            
        })
        .frame(width: UIScreen.main.bounds.width)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Item: Identifiable, Hashable {
    let title: String
    let id = UUID()
    var isExceeded = false
    var isSelected = false
}
