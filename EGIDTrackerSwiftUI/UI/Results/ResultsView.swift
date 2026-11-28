//
//  ResultsView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/30/26.
//


import SwiftUI

struct ResultsView: View {
    @StateObject private var viewModel: ResultsViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var goToButtons = false
    @State private var goToReport = false
    @State private var showStartPicker = false
    @State private var showEndPicker = false
    @State private var tempStartDate = Date()
    @State private var tempEndDate = Date()

    private let purple = Color(red: 91.0 / 255.0, green: 58.0 / 255.0, blue: 130.0 / 255.0)
    private let coral = Color(red: 255.0 / 255.0, green: 143.0 / 255.0, blue: 112.0 / 255.0)
    private let placeholder = Color(red: 145.0 / 255.0, green: 135.0 / 255.0, blue: 165.0 / 255.0)

    init(source: ResultsSource) {
        _viewModel = StateObject(
            wrappedValue: ResultsViewModel(source: source)
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            headerView

            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    Text("Report an exposure")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(purple)

                    dateFilterView

                    if let error = viewModel.errorMessage {
                        errorView(message: error)
                    }

                    resultsHeader
                    resultsContent
                }
                .padding(.horizontal, 20)
                .padding(.top, 28)
                .padding(.bottom, 30)
            }
            .background(Color.white)
        }
        .background(Color.white.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            footerView
        }
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.light)
        .task {
            await viewModel.loadResults()
        }
        .onChange(of: viewModel.startDate) { _ in
            Task {
                await viewModel.loadResults()
            }
        }
        .onChange(of: viewModel.endDate) { _ in
            Task {
                await viewModel.loadResults()
            }
        }
        .background {
            NavigationLink(
                destination: EndoscopyButtonsView(
                    startDate: viewModel.startDate,
                    endDate: viewModel.endDate
                ),
                isActive: $goToButtons
            ) {
                EmptyView()
            }
            .hidden()

            NavigationLink(
                destination: ReportView(
                    source: viewModel.source,
                    section: nil as EndoscopySection?,
                    startDate: viewModel.startDate,
                    endDate: viewModel.endDate
                ),
                isActive: $goToReport
            ) {
                EmptyView()
            }
            .hidden()
        }
        .sheet(isPresented: $showStartPicker) {
            datePickerSheet(
                title: "Start Date",
                selectedDate: $tempStartDate,
                isPresented: $showStartPicker,
                onClear: {
                    viewModel.startDate = nil
                },
                onDone: {
                    viewModel.startDate = tempStartDate
                }
            )
        }
        .sheet(isPresented: $showEndPicker) {
            datePickerSheet(
                title: "End Date",
                selectedDate: $tempEndDate,
                isPresented: $showEndPicker,
                onClear: {
                    viewModel.endDate = nil
                },
                onDone: {
                    viewModel.endDate = tempEndDate
                }
            )
        }
    }

    // MARK: - Header

    private var headerView: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(purple)
                    .frame(width: 38, height: 38)
                    .background(Color.white)
                    .clipShape(Circle())
            }

            Spacer()

            Text("Results")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)

            Spacer()

            Color.clear
                .frame(width: 38, height: 38)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity)
        .frame(height: 134, alignment: .bottom)
        .background(purple)
    }

    // MARK: - Date Filters

    private var dateFilterView: some View {
        HStack(alignment: .top, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Start Date")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(purple)

                dateButton(
                    date: viewModel.startDate,
                    placeholder: "mm/dd/yyyy"
                ) {
                    tempStartDate = viewModel.startDate ?? Date()
                    showStartPicker = true
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("End Date")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(purple)

                dateButton(
                    date: viewModel.endDate,
                    placeholder: "mm/dd/yyyy"
                ) {
                    tempEndDate = viewModel.endDate ?? Date()
                    showEndPicker = true
                }
            }
        }
    }

    private func dateButton(
        date: Date?,
        placeholder: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(
                    date?.formatted(
                        .dateTime
                            .month(.twoDigits)
                            .day(.twoDigits)
                            .year(.defaultDigits)
                    ) ?? placeholder
                )
                .font(.system(size: 17))
                .foregroundColor(placeholderColor(for: date))

                Spacer(minLength: 2)

                Image(systemName: "calendar")
                    .font(.system(size: 23, weight: .medium))
                    .foregroundColor(purple)
            }
            .padding(.horizontal, 13)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(purple, lineWidth: 1.3)
            }
        }
        .buttonStyle(.plain)
    }

    private func placeholderColor(for date: Date?) -> Color {
        date == nil ? placeholder : purple
    }

    // MARK: - Error Message

    private func errorView(message: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Couldn't load scores")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(purple)

            Text(message)
                .font(.system(size: 13))
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(
            Color(
                red: 255.0 / 255.0,
                green: 225.0 / 255.0,
                blue: 218.0 / 255.0
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 17))
    }

    // MARK: - Results Header

    private var resultsHeader: some View {
        HStack {
            Text("Date")
            Spacer()
            Text("Score")
        }
        .font(.system(size: 16, weight: .bold))
        .foregroundColor(purple)
    }

    // MARK: - Results Content

    @ViewBuilder
    private var resultsContent: some View {
        if viewModel.isLoading {
            ProgressView()
                .tint(purple)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 35)
        } else {
            switch viewModel.source {
            case .endoscopy:
                if viewModel.endoscopyResults.isEmpty {
                    emptyResultsView
                } else {
                    VStack(spacing: 0) {
                        ForEach(viewModel.endoscopyResults) { result in
                            NavigationLink {
                                EndoscopyView(reportId: result.id)
                            } label: {
                                resultRow(
                                    date: result.date,
                                    score: result.totalScore
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

            case .symptomChecker, .qol:
                if viewModel.scoreResults.isEmpty {
                    emptyResultsView
                } else {
                    VStack(spacing: 0) {
                        ForEach(viewModel.scoreResults) { result in
                            resultRow(
                                date: result.date,
                                score: result.totalScore
                            )
                        }
                    }
                }
            }
        }
    }

    private var emptyResultsView: some View {
        Text("No scores in this date range.")
            .font(.system(size: 16))
            .foregroundColor(placeholder)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .frame(height: 130)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        purple,
                        style: StrokeStyle(
                            lineWidth: 1.3,
                            dash: [2, 2]
                        )
                    )
            }
    }

    private func resultRow(date: Date, score: Int) -> some View {
        HStack {
            Text(date.formatted(date: .numeric, time: .omitted))
            Spacer()
            Text("\(score)")
        }
        .font(.system(size: 15))
        .foregroundColor(.black)
        .padding(.horizontal, 18)
        .frame(height: 58)
        .background(Color.white)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(purple.opacity(0.25))
                .frame(height: 0.5)
        }
    }

    // MARK: - Footer

    private var footerView: some View {
        Button {
            switch viewModel.source {
            case .endoscopy:
                goToButtons = true

            case .symptomChecker, .qol:
                goToReport = true
            }
        } label: {
            Text("Generate report")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(coral)
                .frame(maxWidth: .infinity)
                .frame(height: 58)
                .background(purple)
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .padding(.horizontal, 38)
        .padding(.top, 12)
        .padding(.bottom, 12)
        .background(Color.white)
    }

    // MARK: - Date Picker Sheet

    private func datePickerSheet(
        title: String,
        selectedDate: Binding<Date>,
        isPresented: Binding<Bool>,
        onClear: @escaping () -> Void,
        onDone: @escaping () -> Void
    ) -> some View {
        NavigationStack {
            VStack(spacing: 20) {
                DatePicker(
                    title,
                    selection: selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .tint(purple)

                HStack {
                    Button("Clear", role: .destructive) {
                        onClear()
                        isPresented.wrappedValue = false
                    }

                    Spacer()

                    Button("Done") {
                        onDone()
                        isPresented.wrappedValue = false
                    }
                    .foregroundColor(purple)
                }
            }
            .padding()
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    NavigationStack {
        ResultsView(source: .qol)
    }
}
