//
//  CalendarView.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/7/26.
//
import SwiftUI
import WebKit

struct CalendarView: View {
    private let calendarURL = URL(string:
        "https://calendar.google.com/calendar/embed?height=400&wkst=2&bgcolor=%23efeded&ctz=America%2FNew_York&src=ZmVzY2FsZW5kYXJAZmVzY2VudGVyLm9yZw&color=%233F51B5&showCalendars=0&showTabs=0&showDate=0&showPrint=0&showTitle=0&showNav=0&showTz=0&mode=AGENDA"
    )!

    var body: some View {
        WebView(url: calendarURL)
            .frame(height: 400)
            .navigationTitle("Events")
            .navigationBarTitleDisplayMode(.inline)
    }
}
