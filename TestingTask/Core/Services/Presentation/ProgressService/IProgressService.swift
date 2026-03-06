//
//  IProgressService.swift
//  TestingTask
//

import Foundation

//sourcery: AutoMockable
protocol IProgressService {
    func show()
    func showWithoutDim()
    func showWithoutDim(timeOut: Int)
    func show(style: ProgressStyle)
    func showWithoutDim(style: ProgressStyle)
    func hide()
    var isShown: Bool { get }
}
