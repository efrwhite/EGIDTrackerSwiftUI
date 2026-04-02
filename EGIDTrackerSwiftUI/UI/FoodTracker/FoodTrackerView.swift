import SwiftUI

struct FoodTrackerView: View {
    
    @StateObject private var viewModel = FoodTrackerViewModel()
    @State private var selectedDate = Date()
    @State private var showAdd = false
    @State private var editingEntry: FoodEntry?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                Text("Food Tracker")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Button("Add") {
                    editingEntry = nil
                    showAdd = true
                }
                .font(.title3)
            }
            
            HStack {
                Spacer()
                
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .labelsHidden()
                .onChange(of: selectedDate) { newDate in
                    viewModel.updateDate(newDate)
                    Task { await viewModel.loadEntries() }
                }
            }
            
            Group {
                if viewModel.entries.isEmpty {
                    VStack {
                        Spacer()
                        Text("No entries for this date.")
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.entries) { entry in
                            HStack {
                                Text(entry.foodName)
                                
                                Spacer()
                                
                                Button("Edit") {
                                    editingEntry = entry
                                    showAdd = true
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .navigationTitle("Food Tracker")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.updateDate(selectedDate)
            Task { await viewModel.loadEntries() }
        }
        .sheet(isPresented: $showAdd) {
            AddFoodView(
                existingEntry: editingEntry,
                selectedDate: viewModel.selectedDate
            ) {
                Task { await viewModel.loadEntries() }
            }
        }
    }
}
