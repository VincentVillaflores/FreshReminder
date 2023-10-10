//
//  NewItemView.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 27/8/2023.
//  with inspirations from ContentView.swift by Leon Wei on 5/31/21.
//

import SwiftUI

/// A view to add a new item to the fridge.
/// It allows the user to input an item's name or to use camera or photo library to identify an item using an image classifier. 
struct NewItemView: View {
    @EnvironmentObject var cdvm: CoreDataViewModel
    
    @State var isPresenting: Bool = false
    @State var uiImage: UIImage?
    @ObservedObject var classifier = ImageClassifier()
    @State var sourceType: UIImagePickerController.SourceType = .camera
    
    @State
    var itemName = ""
        
    var body: some View {
        VStack{
            Form {
                Section(header: Text("Item Name")) {
                    TextField("Name", text: $itemName)
                }
                NavigationLink("Search", value: itemName)
                    .disabled(itemName.count < 3)
            }.navigationTitle("Search Item")
            
            Spacer()
            
            HStack{
                Image(systemName: "photo")
                    .onTapGesture {
                        isPresenting = true
                        sourceType = .photoLibrary
                    }
                
                Image(systemName: "camera")
                    .onTapGesture {
                        isPresenting = true
                        sourceType = .camera
                    }
            }
            
            Spacer()
        }
        .sheet(isPresented: $isPresenting){
            ImagePicker(uiImage: $uiImage, isPresenting:  $isPresenting, sourceType: $sourceType)
                .onDisappear{
                    if uiImage != nil {
                        classifier.detect(uiImage: uiImage!)
                        itemName = classifier.imageClass ?? "nothing"
                    }
                }
        }
        .padding()
    }
}

#if DEBUG
struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        MockNewItemView()
    }
}

struct MockNewItemView: View {
    let persistenceController = PersistenceController.shared
    @StateObject private var cdvm: CoreDataViewModel
    init(){
        let context = persistenceController.container.viewContext
        _cdvm = StateObject(wrappedValue: CoreDataViewModel(context: context))
        cdvm.setUp()
    }
    
    var body: some View {
        NavigationStack {
            NewItemView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(cdvm)
        }
    }
}
#endif
