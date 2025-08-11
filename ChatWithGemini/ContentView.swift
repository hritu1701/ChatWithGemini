import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    let model=GenerativeModel(name:"gemini-1.5-flash", apiKey: APIKey.default)
    @State private var userPrompt = ""
    @State private var response = "How can I help you today?"
    @State var isLoading = false
    
    var body: some View {
        VStack {
            Text("Welcome to Gemini AI")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.indigo)
                .padding(.top, 40)
            ZStack{
                ScrollView{
                    Text(response)
                        .font(.title)
                }
                if isLoading{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint:.indigo))
                        .scaleEffect(4)
                }
            }
            TextField("Ask anything.....",text: $userPrompt,axis:.vertical)
                .lineLimit(5)
                .font(.title)
                .padding()
                .background(Color.indigo.opacity(0.2),in: Capsule())
                .autocorrectionDisabled(true)
                .onSubmit {
                    generateResponse()
                }
            
        }
        .padding()
    }
    func generateResponse(){
        isLoading = true
        response=""
        Task{
            do{
                let result = try await model.generateContent(userPrompt)
                isLoading = false
                response = result.text ?? "No response found"
                userPrompt=""
            }
            catch{
                response="Something went wrong\n\(error.localizedDescription)"
                
            }
        }
    }
}

#Preview {
    ContentView()
}
