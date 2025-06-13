# Experimental!
I ~ "git: github.com/Marcos-cat/iris"

I~Open 160_320 "TetrIris"

◌°img &frab "block.png"
Cyan_Blue_Orange_Yellow_Green_Magenta_Red
≡⌟(I~Texture~LoadImage ≡₁⌞⬚1×)
BlockTextures ← # colored blocks loaded as textures

┌─╴Piece
  # Types are, in order: I, J, L, O, S, T and Z
  ~ {Type Rotation Position}
  # create piece of type
  FromType ← Piece⊙0⊙0_2
└─╴
Pieces ← ⋯[
  0_0_30_0_0  # I
  0_2_14_0_0  # J
  0_8_14_0_0  # L
  0_12_12_0_0 # O
  0_12_6_0_0  # S
  0_4_14_0_0  # T
  0_6_12_0_0  # Z
]
PieceOffsets ← ⊏1_0_0_2_0_0_0[
  {◠⊙≡⍜⊣¯ ↯5 0_0 [0_0 0_1 1_1 ¯2_0 ¯2_1]} # normal offsets
  # special cases:
  {[0_0 ◡⊙∘ 0_¯1 0_2] [0_¯1 .0_0 ¯1_0 2_0] [¯1_¯1 ¯1_1 ¯1_¯2 0_1 0_¯2] [..¯1_0 1_0 ¯2_0]} # I
  {[0_0] [1_0] [1_¯1] [0_¯1]}                                                             # O
]

┌─╴Game
  ~ {Board CurPiece Bag Gravity HeldPiece}

  PullFromBag ← (
    ⊸Bag                             # get bag
    ⍥⋅(°⍆⇡7)=0⊸⧻                     # reshuffle if empty
    ⊙(°⊸CurPiece Piece~FromType) °˜⊂ # pull a piece
    °⊸Bag                            # update bag (tbh could've used under)
    ⍜(⊢ Gravity)⋅0                   # forgot to reset gravity
  )
  Hold ← (
    ⊸(=¯1HeldPiece)
    ⨬(°⊸CurPiece⊙°⊸HeldPiece Piece~FromType : Piece~Type ⊸⊃CurPiece HeldPiece # piece already in hold
    | PullFromBag°⊸HeldPiece Piece~Type⊸CurPiece                              # no held piece
    )
  )
  # this is also a collision check >:)
  # Could NewGame ? OldGame
  PutPieceInBoard ↚ (
    ⊸CurPiece                                                  # get piece
    ×⊃(+₁ Piece~Type|˜(↻¯+3_3)⬚0↙29_16 ˜⍥(⍉⇌) ⊏⊙Pieces °Piece) # do the right stuff with the piece
    ⟜⨬◌⍜⊙Board(⬚0+↘¯⟜↘3_3) ⤚(¬/↥♭⬚0×∩±) ⊙⊸⬚1(⌝↘¯⟜⌝↘3_3 Board)  # actually try putting it in the board
  )
  # Could NewGame ? Translation OldGame
  MovePiece ← ⟜⨬⋅∘∘ ⊙◌⊸PutPieceInBoard⊸⍜⊙(Piece~Position CurPiece)+
  # NewGame ? Angle Game
  Rotate ← (
    ⤚(-∩⌟⊏ ◿4⊸+) ⊙⊸(Piece!⊃Rotation(⊏⊙PieceOffsets Type) CurPiece) # get offsets
    ◇≡⌟MovePiece ⊙⊸⍜⊙(Piece~Rotation CurPiece)(◿4+)                # do all the rotations
    ⍣(⍜(⊢ Gravity)⋅0 ⊏⊢⊚ ⊙⊙◌)⋅⋅∘
  )
  Land ↚ (
    °1PutPieceInBoard
    ⍜(⇌ Board|⬚0↙23▽¬≡/×⊸±) # line clears!
    PullFromBag
    ⍥(&exit0)¬ ⊙◌⊸PutPieceInBoard # lose by exiting
  )
  # NewGame ? OldGame
  HandleGravity ← (
    ⍜(⊢ Gravity|+I~Dt)                                  # add gravity
    ⟜⤙⍥(◌MovePiece 1_0) ⊃(⌊÷|°⊸(⊢Gravity)◿)°˜⊟ ⊸Gravity # do the gravity
    ⍥Land ×⊙⊸≍                                          # land if gravity acted and nothing happened
  )
  # TODO: Fix bug where pressing the hard drop button when the piece is already touching the floor makes you automatically lose.
  HardDrop ← ⍥Land¬⊸(⊙◌MovePiece 1_0) HandleGravity⍜(⊢Gravity)+₂₀

  DrawBoard ← (
    ↘3Board                                         # drop the 3 invisible rows
    ×16°⊡⍉                                          # coords
    ⨬◌(I~Draw~Texture⊙16_16 ⊡⊙BlockTextures-1)˜⊃±⊙∘ # drawing
  )
  DrawWithPiece ← DrawBoard°1 PutPieceInBoard

  New ← PullFromBag {
    ↯23_10 0      # 20×10 board with 3 invisible rows on top
    Piece 0 0 0_0 # dummy piece
    []            # empty bag
    0_1/5         # Current_G
    ¯1            # no hold piece
  }
└─╴

Game

I~Loop!(
  I~Key~Pressed‼(I~Key~Arrow@<|◌Game~MovePiece 0_¯1) # left
  I~Key~Pressed‼(I~Key~Arrow@>|◌Game~MovePiece 0_1)  # right
  I~Key~Down‼(I~Key~Arrow@^)⍜(⊢ Game~Gravity|+I~Dt)  # soft-drop; ⨯2 gravity
  I~Key~Pressed‼(I~Key~Arrow@v)Game~HardDrop         # hard-drop; 20g lock-on
  I~Key~Pressed‼@Z(Game~Rotate ¯1)                   # ccw rotation
  I~Key~Pressed‼@X(Game~Rotate 1)                    # cw rotation
  I~Key~Pressed‼@CGame~Hold                          # hold
  I~Key~Pressed‼@V(Game~Rotate 2)                    # 180° rotation
  Game~HandleGravity

  I~Draw~Background Black
  ⊸Game~DrawWithPiece
)

◌
