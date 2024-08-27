//
//  ContentView.swift
//  MyTestApp
//
//  Created by Ariel Liscovsky on 20/08/2024.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoginActive: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Enter Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                    .autocapitalization(.none)
                
                SecureField("Enter Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                
                Button(action: {
                    isLoginActive = true
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .background(username.isEmpty || password.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(10)
                }
                .disabled(username.isEmpty || password.isEmpty)
                .background(
                    NavigationLink(destination: LevelsView(), isActive: $isLoginActive) {
                        EmptyView()
                    }
                )
                
                Button(action: {
                    print("Sign Up button pressed")
                }) {
                    Text("Sign Up")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .padding()
        }
    }
}

struct LevelsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Select a Level")
                .font(.largeTitle)
                .padding()
            
            NavigationLink(destination: Level1View()) {
                Text("Level 1")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            
            NavigationLink(destination: Level2View()) {
                Text("Level 2")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            
            NavigationLink(destination: Level3View()) {
                Text("Level 3")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            
            NavigationLink(destination: Level4View()) {
                Text("Level 4")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Levels")
    }
}

struct Level1View: View {
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var isSubmitEnabled: Bool = false
    @State private var isLevel2Active: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
                .keyboardType(.emailAddress)
                .onChange(of: email) { _ in
                    checkFormCompletion()
                }
            
            TextField("Enter Phone Number", text: $phoneNumber)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
                .keyboardType(.phonePad)
                .onChange(of: phoneNumber) { _ in
                    checkFormCompletion()
                }
            
            Button(action: {
                isLevel2Active = true
            }) {
                Text("Submit")
                    .foregroundColor(.white)
                    .padding()
                    .background(isSubmitEnabled ? Color.blue : Color.gray)
                    .cornerRadius(10)
            }
            .disabled(!isSubmitEnabled)
            .background(
                NavigationLink(destination: Level2View(), isActive: $isLevel2Active) {
                    EmptyView()
                }
            )
        }
        .padding()
        .navigationTitle("Level 1")
    }
    
    private func checkFormCompletion() {
        isSubmitEnabled = !email.isEmpty && !phoneNumber.isEmpty
    }
}

struct Level2View: View {
    @State private var toggleState = false
    @State private var sliderValue: Double = 0
    @State private var isProceedEnabled: Bool = false
    @State private var isLevel3Active: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Toggle(isOn: $toggleState) {
                Text("Enable Feature")
            }
            .padding()
            .onChange(of: toggleState) { _ in
                checkProceedCondition()
            }
            
            Slider(value: $sliderValue, in: 0...100)
                .padding()
                .onChange(of: sliderValue) { _ in
                    checkProceedCondition()
                }
            
            Button(action: {
                isLevel3Active = true
            }) {
                Text("Proceed")
                    .foregroundColor(.white)
                    .padding()
                    .background(isProceedEnabled ? Color.blue : Color.gray)
                    .cornerRadius(10)
            }
            .disabled(!isProceedEnabled)
            .background(
                NavigationLink(destination: Level3View(), isActive: $isLevel3Active) {
                    EmptyView()
                }
            )
        }
        .padding()
        .navigationTitle("Level 2")
    }
    
    private func checkProceedCondition() {
        isProceedEnabled = sliderValue > 50 && toggleState
    }
}

struct Level3View: View {
    @State private var pickerSelection = 1
    @State private var isLevel4Enabled: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage? = nil
    @State private var showCustomAlert: Bool = false
    @State private var isLevel4Active: Bool = false

    let pickerOptions = ["Option 1", "Option 2", "Option 3"]

    var body: some View {
        VStack(spacing: 20) {
            Picker("Choose an option", selection: $pickerSelection) {
                ForEach(0..<pickerOptions.count) {
                    Text(self.pickerOptions[$0])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if pickerSelection == 1 {
                Button(action: {
                    showImagePicker = true
                }) {
                    Text("Add Image")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }
            }

            if selectedImage != nil && pickerSelection == 1 {
                Image(uiImage: selectedImage!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(10)
                    .onAppear {
                        enableLevel4()
                    }
            }

            Button(action: {
                if isLevel4Enabled {
                    showCustomAlert = true
                }
            }) {
                Text("Finish")
                    .foregroundColor(.white)
                    .padding()
                    .background(isLevel4Enabled ? Color.blue : Color.gray)
                    .cornerRadius(10)
            }
            .disabled(!isLevel4Enabled)
            .alert(isPresented: $showCustomAlert) {
                Alert(
                    title: Text("Confirmation"),
                    message: Text("Are you sure you want to continue?"),
                    primaryButton: .default(Text("Yes")) {
                        isLevel4Active = true
                    },
                    secondaryButton: .cancel(Text("No"))
                )
            }

            NavigationLink(destination: Level4View(), isActive: $isLevel4Active) {
                EmptyView()
            }
        }
        .padding()
        .navigationTitle("Level 3")
    }

    private func enableLevel4() {
        isLevel4Enabled = true
    }
}



struct Level4View: View {
    @State private var selectedItem1: Int? = nil
    @State private var selectedItem2: Int? = nil
    @State private var isEndEnabled: Bool = false
    @State private var isEndActive: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<5) { index in
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .background(index == selectedItem1 ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .onTapGesture {
                                selectedItem1 = index
                                checkSelection()
                            }
                    }
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<5) { index in
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .background(index == selectedItem2 ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .onTapGesture {
                                selectedItem2 = index
                                checkSelection()
                            }
                    }
                }
            }
            
            Button(action: {
                isEndActive = true
            }) {
                Text("End")
                    .foregroundColor(.white)
                    .padding()
                    .background(isEndEnabled ? Color.blue : Color.gray)
                    .cornerRadius(10)
            }
            .disabled(!isEndEnabled)
            .background(
                NavigationLink(destination: CongratulationsView(), isActive: $isEndActive) {
                    EmptyView()
                }
            )
        }
        .padding()
        .navigationTitle("Level 4")
    }
    
    private func checkSelection() {
        isEndEnabled = (selectedItem1 == 4 && selectedItem2 == 4)
    }
}

struct CongratulationsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Congratulations!")
                .font(.largeTitle)
                .padding()
            
            Text("You have successfully automated the basic UI elements in iOS.")
                .font(.title2)
                .padding()
            
            Button(action: {
                print("Back to Start")
            }) {
                Text("Back to Start")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Completion")
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
