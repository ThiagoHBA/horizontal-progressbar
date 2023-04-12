import XCTest
import SpriteKit
@testable import HorizontalProgressBar

final class HorizontalProgressBarTests: XCTestCase {
    func test_backbar_should_be_behind_foreground() throws {
        let sut = makeSUT()
        XCTAssertLessThan(sut.backBar.zPosition, sut.foregroundBar.zPosition)
    }
    
    func test_progressValue_should_be_zero_if_ascending() {
        let sut = makeSUT(ascending: true)
        XCTAssertEqual(sut.progressValue, 0)
    }
    
    func test_progressValue_should_be_max_if_not_ascending() {
        let sut = makeSUT(ascending: false)
        XCTAssertEqual(sut.progressValue, sut.maxProgressValue)
    }
    
    func test_should_initialize_padding_as_10() {
        let sut = makeSUT()
        XCTAssertEqual(sut.padding, 10)
    }
    
    func test_when_set_padding_should_rebuild_bar() {
        let sut = makeSUT()
        sut.padding = 5
        XCTAssertEqual(sut.padding, 5)
    }
    
    func test_when_set_padding_foreground_should_remain_on_top_of_backbar_horizontaly() {
        let sut = makeSUT()
        sut.padding = 5
        XCTAssertEqual(sut.foregroundBar.frame.minX - sut.padding, sut.backBar.frame.minX)
    }
    
    func test_when_set_padding_foreground_should_remain_on_top_of_backbar_verticaly() {
        let sut = makeSUT()
        sut.padding = 5
        XCTAssertEqual(sut.foregroundBar.position.y, sut.backBar.position.y)
    }
    
    func test_when_texture_setted_should_positionate_correctly() {
        let sut = makeSUT()
        let previousPosition = sut.position
        sut.backTexture = SKTexture(image: UIImage(systemName: "star")!)
        XCTAssertEqual(previousPosition, sut.position)
    }
    
    func test_when_backTexture_setted_use_new_texture() {
        let sut = makeSUT()
        let inputedTexture = SKTexture(image: UIImage(systemName: "star")!)
        sut.backTexture = inputedTexture
        XCTAssertEqual(sut.backBar.texture, inputedTexture)
    }
    
    func test_when_foregroundTexture_setted_use_new_texture() {
        let sut = makeSUT()
        let inputedTexture = SKTexture(image: UIImage(systemName: "star")!)
        sut.foregroundTexture = inputedTexture
        XCTAssertEqual(sut.foregroundBar.texture, inputedTexture)
    }
    
    func test_when_inputTexture_is_nil_texture_should_not_be_nil() {
        let sut = makeSUT()
        sut.backTexture = nil
        sut.foregroundTexture = nil
        XCTAssertNotNil(sut.backBar.texture)
        XCTAssertNotNil(sut.foregroundBar.texture)
    }
    
    func test_init_coder_should_return_nil() {
        let sut = HorizontalProgressBar(coder: NSCoder())
        XCTAssertNil(sut)
    }
    
    func test_if_ascending_should_increase_bar_value() {
        let sut = makeSUT(ascending: true)
        sut.factor = 10
        sut.updateBarState()
        XCTAssertEqual(sut.progressValue, 10)
    }
    
    func test_if_not_ascending_should_decrease_bar_value() {
        let sut = makeSUT()
        sut.factor = 20
        sut.updateBarState()
        XCTAssertEqual(sut.progressValue, 80)
    }
    
    func test_ascending_when_complete_progress_value_should_be_equal_as_max_value() {
        let sut = makeSUT(ascending: true)
        sut.factor = 1000
        sut.updateBarState()
        XCTAssertEqual(sut.progressValue, sut.maxProgressValue)
    }
    
    func test_not_ascending_when_complete_progress_value_should_be_equal_as_zero() {
        let sut = makeSUT()
        sut.factor = 1000
        sut.updateBarState()
        XCTAssertEqual(sut.progressValue, 0)
    }
    
    func test_setProgressValue_when_receive_value_should_set_correctly() {
        let sut = makeSUT()
        sut.updateProgressValue(with: 10.0)
        XCTAssertEqual(sut.progressValue, 10.0)
    }
    
    func test_setProgressValue_when_receive_values_more_than_max_should_set_correctly() {
        let sut = makeSUT()
        sut.updateProgressValue(with: 500)
        XCTAssertEqual(sut.progressValue, 100.0)
    }
    
    func test_setProgressValue_when_receive_values_more_than_zero_should_set_correctly() {
        let sut = makeSUT()
        sut.updateProgressValue(with: -500)
        XCTAssertEqual(sut.progressValue, 0)
    }
}

extension HorizontalProgressBarTests {
    func makeSUT(ascending: Bool = false) -> HorizontalProgressBar {
        let sut = HorizontalProgressBar(
            isAscending: ascending,
                size: CGSize(
                width: 150,
                height: 150
            )
        )
        return sut
    }
}
