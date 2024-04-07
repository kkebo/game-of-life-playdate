private import GameOfLife
public import Playdate

nonisolated(unsafe) var game: Game!

@_cdecl("eventHandler")
public func eventHandler(
    pointer: UnsafeMutableRawPointer!,
    event: PDSystemEvent,
    arg: UInt32
) -> Int32 {
    if event == .initialize {
        initializePlaydateAPI(with: pointer)
        Display.setScale(s: 8)
        System.setUpdateCallback(update: { _ in game.update() ? 1 : 0 }, userdata: nil)
        game = Game()
    }
    return 0
}

final class Game {
    private var automaton: CellularAutomaton
    private var frame: UnsafeMutablePointer<UInt8>

    init() {
        self.automaton = .init(width: Int(Display.width), height: Int(Display.height))
        self.frame = Graphics.getDisplayFrame()!

        self.automaton.putRPentomino()
    }

    func update() -> Bool {
        if System.buttonState.pushed == .a {
            self.reset()
        } else {
            self.automaton.next()
        }

        for y in 0..<self.automaton.height {
            for x in 0..<self.automaton.width {
                Graphics.fillRect(
                    x: CInt(x),
                    y: CInt(y),
                    width: 1,
                    height: 1,
                    color: self.automaton[x, y] ? 1 : 0
                )
            }
        }

        return true
    }

    func reset() {
        self.automaton.clear()
        self.automaton.putRPentomino()
    }
}
