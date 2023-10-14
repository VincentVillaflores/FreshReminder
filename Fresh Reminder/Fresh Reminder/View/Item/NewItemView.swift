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
    @State var isPresenting: Bool = false
    @State var uiImage: UIImage?
    @StateObject var classifier = ImageClassifier()
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var errorPopup = false
    
    @State
    var itemName = ""
        
    var body: some View {
        VStack{
            Form {
                Section(header: Text("Item Name")) {
                    HStack{
                        TextField("Name", text: $itemName)
                        
                        Menu {
                            Button {
                                isPresenting = true
                                sourceType = .camera
                            } label: {
                                Label("Take Photo", systemImage: "camera")
                            }
                            
                            Button {
                                isPresenting = true
                                sourceType = .photoLibrary
                            } label: {
                                Label("Photo Library", systemImage: "photo.on.rectangle")
                            }
                            
                        } label: {
                            Image(systemName: "photo")
                        }.buttonStyle(.bordered)
                    }
                }
                
                NavigationLink("Search", value: itemName)
                    .disabled(itemName.count < 3)
            }.navigationTitle("New Item")
             
        }
        .sheet(isPresented: $isPresenting){
            ImagePicker(uiImage: $uiImage, isPresenting:  $isPresenting, sourceType: $sourceType)
                .onDisappear{
                    if uiImage != nil {
                        classifier.detect(uiImage: uiImage!)
                        switch classifier.imageClass {
                        case nil:
                            errorPopup = true
                        default:
                            itemName = classifier.imageClass ?? ""
                        }
                    }
                }
        }.alert("Couldn't find food in this image. Please try again.",
                isPresented: $errorPopup) {
            Button("OK", role: .cancel) {}
        }
    }
}

#if DEBUG
struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        MockNewItemView()
    }
}

struct MockNewItemView: View {
    var body: some View {
        NavigationStack {
            NewItemView()
        }
    }
}
#endif
