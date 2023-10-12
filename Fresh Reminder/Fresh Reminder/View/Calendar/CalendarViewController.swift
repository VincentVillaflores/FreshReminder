//
//  CalendarViewController.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 12/10/2023.
//

import SwiftUI
import UIKit


struct CalendarViewController: UIViewControllerRepresentable {
    let dateSet: Set<Date>
    
    @Binding
    var monthOffset: Int
    
    @Binding
    var selectedDate: Date
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator

        pageViewController.setViewControllers([UIHostingController(rootView: CalendarGrid(selectedDate: $selectedDate, monthOffset: monthOffset, dateSet: dateSet))], direction: .forward, animated: false, completion: nil)
        
        return pageViewController
    }


    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        let prevViewController = pageViewController.viewControllers?.first as? UIHostingController<CalendarGrid>
        let prevIndex = prevViewController?.rootView.monthOffset ?? monthOffset
        
        if monthOffset != prevIndex {
            let direction: UIPageViewController.NavigationDirection = (monthOffset > prevIndex) ? .forward : .reverse
            pageViewController.setViewControllers([UIHostingController(rootView: CalendarGrid(selectedDate: $selectedDate, monthOffset: monthOffset, dateSet: dateSet))], direction: direction, animated: true, completion: nil)
        }
    }

    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: CalendarViewController

        init(_ pageViewController: CalendarViewController) {
            parent = pageViewController
        }


        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController) -> UIViewController?
        {
            if let currView = viewController as? UIHostingController<CalendarGrid> {
                let prevIndex = currView.rootView.monthOffset - 1
                
                return UIHostingController(rootView: CalendarGrid(selectedDate: parent.$selectedDate, monthOffset: prevIndex, dateSet: parent.dateSet))
            }
            
            return nil
        }


        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController?
        {
            if let currView = viewController as? UIHostingController<CalendarGrid> {
                let nextIndex = currView.rootView.monthOffset + 1
                
                return UIHostingController(rootView: CalendarGrid(selectedDate: parent.$selectedDate, monthOffset: nextIndex, dateSet: parent.dateSet))
            }
            
            return nil
        }


        func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first as? UIHostingController<CalendarGrid> {
                let index = visibleViewController.rootView.monthOffset
                parent.monthOffset = index
            }
        }
    }
}
