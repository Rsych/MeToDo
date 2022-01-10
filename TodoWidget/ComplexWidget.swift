//
//  ComplexWidget.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/29.
//

import SwiftUI
import WidgetKit

struct TodoWidgetMultipleEntryView: View {
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.sizeCategory) var sizeCategory

    var entry: Provider.Entry

    var items: ArraySlice<Item> {
        let itemCount: Int

        switch widgetFamily {
        case .systemSmall:
            itemCount = 1
        case .systemLarge:
            if sizeCategory < .extraExtraLarge {
                itemCount = 5
            } else {
                itemCount = 4
            }
        default:
            if sizeCategory < .extraLarge {
                itemCount = 2
            } else {
                itemCount = 2
            }
        }

        return entry.items.prefix(itemCount)
    }

    var body: some View {
        VStack(spacing: 5) {
            ForEach(items) { item in
                Link(destination: URL(string: item.objectID.uriRepresentation().absoluteString)!) {
                    HStack {
                        Color(item.project?.color ?? "Light Blue")
                            .frame(width: 5)
                            .clipShape(Capsule())

                        VStack(alignment: .leading) {
                            Text(item.itemTitle)
                                .font(.headline)
                                .layoutPriority(1)

                            if let projectTitle = item.project?.projectTitle {
                                Text(projectTitle)
                                    .foregroundColor(.secondary)
                            }
                            if let projectDue = item.project?.projectDue {
                                Text("Due: \(projectDue)")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }  //: VStack
                        Spacer()
                    }  //: HStack
                } //: Link
            }  //: Loop
        }  //: VStack
        .padding(20)
    }
}

struct ComplexTodoWidget: Widget {
    let kind: String = "ComplexTodoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TodoWidgetMultipleEntryView(entry: entry)
        }
        .configurationDisplayName("Up next…")
        .description("Your most important tasks.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct ComplexWidget_Previews: PreviewProvider {
    static var previews: some View {
        TodoWidgetMultipleEntryView(entry: SimpleEntry(date: Date(), items: [Item.example]))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
