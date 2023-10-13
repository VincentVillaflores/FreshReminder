//
//  CalendarViewController.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 12/10/2023.
//

import SwiftUI
import UIKit


struct CalendarViewController: UIViewControllerRepresentable {
    @EnvironmentObject
    var calendarViewModel: CalendarViewModel
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator

        pageViewController.setViewControllers([UIHostingController(rootView: CalendarGrid(monthOffset: calendarViewModel.monthOffset))], direction: .forward, animated: false, completion: nil)
        
        return pageViewController
    }


    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        let prevViewController = pageViewController.viewControllers?.first as? UIHostingController<CalendarGrid>
        let prevIndex = prevViewController?.rootView.monthOffset ?? calendarViewModel.monthOffset
        
        if calendarViewModel.monthOffset != prevIndex {
            let direction: UIPageViewController.NavigationDirection = (calendarViewModel.monthOffset > prevIndex) ? .forward : .reverse
            pageViewController.setViewControllers([UIHostingController(rootView: CalendarGrid(monthOffset: calendarViewModel.monthOffset))], direction: direction, animated: true, completion: nil)
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
                
                return UIHostingController(rootView: CalendarGrid(monthOffset: prevIndex))
            }
            
            return nil
        }


        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController?
        {
            if let currView = viewController as? UIHostingController<CalendarGrid> {
                let nextIndex = currView.rootView.monthOffset + 1
                
                return UIHostingController(rootView: CalendarGrid(monthOffset: nextIndex))
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
                if index > parent.calendarViewModel.monthOffset {
                    parent.calendarViewModel.nextMonth()
                }
                if index < parent.calendarViewModel.monthOffset {
                    parent.calendarViewModel.prevMonth()
                }
            }
        }
    }
}
