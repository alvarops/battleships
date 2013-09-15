module ShipShapes
  SHIP_TYPES = {
    carrier: [
      [
        {x: 0, y: 0},
        {x: 0, y: 1},
        {x: 0, y: 2},
        {x: 0, y: 3},
        {x: 0, y: 4}
      ],[
        {x: 0, y: 0},
        {x: 1, y: 0},
        {x: 2, y: 0},
        {x: 3, y: 0},
        {x: 4, y: 0}
      ]
    ],
    battleship:[
      [
        {x: 0, y: 0},
        {x: 0, y: 1},
        {x: 0, y: 2},
        {x: 0, y: 3}
      ],[
        {x: 0, y: 0},
        {x: 1, y: 0},
        {x: 2, y: 0},
        {x: 3, y: 0}
      ]
    ],
    submarine: [
      [
        {x: 0, y: 0},
        {x: 0, y: 1},
        {x: 0, y: 2}
      ], [
        {x: 0, y: 0},
        {x: 1, y: 0},
        {x: 2, y: 0}
      ]
    ],
    cruiser: [
      [
        {x: 0, y: 0},
        {x: 0, y: 1},
        {x: 0, y: 2}
      ], [
        {x: 0, y: 0},
        {x: 1, y: 0},
        {x: 2, y: 0}
      ]
    ],
    patrol: [
      [
        {x: 0, y: 0},
        {x: 0, y: 1}
      ], [
        {x: 0, y: 0},
        {x: 1, y: 0}
      ]
    ],
    worm: [
      [
        {x: 0, y: 0},
        {x: 1, y: 0},
        {x: 1, y: 1},
        {x: 1, y: 2},
        {x: 2, y: 2},
        {x: 3, y: 2},
        {x: 4, y: 2},
        {x: 5, y: 2},
        {x: 5, y: 1},
        {x: 6, y: 1},
        {x: 6, y: 2}
      ]
    ],
    uBoot: [
      [
        {x: 0, y: 0},
        {x: 0, y: 1},
        {x: 0, y: 2},
        {x: 1, y: 3},
        {x: 2, y: 3},
        {x: 3, y: 2},
        {x: 3, y: 1},
        {x: 3, y: 0}
      ]
    ],
    s1: [
      [
        {x: 0, y: 0},
        {x: 1, y: 0},
        {x: 2, y: 0},
        {x: 2, y: 1},
        {x: 3, y: 1},
        {x: 4, y: 1}
      ], [
        {x: 1, y: 0},
        {x: 1, y: 1},
        {x: 0, y: 2},
        {x: 1, y: 2},
        {x: 0, y: 3},
        {x: 0, y: 4}
      ]
    ],
    tie_fighter: [
      [
        {x: 0, y: 0},
        {x: 2, y: 0},
        {x: 0, y: 1},
        {x: 1, y: 1},
        {x: 2, y: 1},
        {x: 0, y: 2},
        {x: 2, y: 2}
      ], [
        {x: 0, y: 0},
        {x: 1, y: 0},
        {x: 2, y: 0},
        {x: 1, y: 1},
        {x: 0, y: 2},
        {x: 1, y: 2},
        {x: 2, y: 2}
      ]
    ],
    enterprise: [
      [
        {x: 6, y: 0},
        {x: 7, y: 0},
        {x: 0, y: 1},
        {x: 1, y: 1},
        {x: 2, y: 1},
        {x: 3, y: 1},
        {x: 4, y: 1},
        {x: 6, y: 1},
        {x: 3, y: 2},
        {x: 6, y: 2},
        {x: 3, y: 3},
        {x: 4, y: 3},
        {x: 5, y: 3},
        {x: 6, y: 3}
      ], [
        {x: 0, y: 0},
        {x: 1, y: 0},
        {x: 1, y: 1},
        {x: 3, y: 1},
        {x: 4, y: 1},
        {x: 5, y: 1},
        {x: 6, y: 1},
        {x: 7, y: 1},
        {x: 1, y: 2},
        {x: 4, y: 2},
        {x: 1, y: 3},
        {x: 2, y: 3},
        {x: 3, y: 3},
        {x: 4, y: 3}
      ]
    ],
    kursk: [
      [
        {x: 3, y: 0},
        {x: 1, y: 1},
        {x: 2, y: 1},
        {x: 3, y: 1},
        {x: 4, y: 1},
        {x: 5, y: 1},
        {x: 0, y: 2},
        {x: 1, y: 2},
        {x: 2, y: 2},
        {x: 3, y: 2},
        {x: 4, y: 2}
      ], [
        {x: 2, y: 0},
        {x: 0, y: 1},
        {x: 1, y: 1},
        {x: 2, y: 1},
        {x: 3, y: 1},
        {x: 4, y: 1},
        {x: 1, y: 2},
        {x: 2, y: 2},
        {x: 3, y: 2},
        {x: 4, y: 2},
        {x: 5, y: 2}
      ]
    ],
    death_star: [
      [
        {x: 1, y: 0},
        {x: 2, y: 0},
        {x: 0, y: 1},
        {x: 2, y: 1},
        {x: 3, y: 1},
        {x: 0, y: 2},
        {x: 1, y: 2},
        {x: 2, y: 2},
        {x: 3, y: 2},
        {x: 1, y: 3},
        {x: 2, y: 3}
      ]
    ],
    crab: [
      [
        {x: 0, y: 0},
        {x: 3, y: 0},
        {x: 4, y: 0},
        {x: 1, y: 1},
        {x: 2, y: 1},
        {x: 2, y: 2},
        {x: 1, y: 3},
        {x: 2, y: 3},
        {x: 0, y: 4},
        {x: 3, y: 4},
        {x: 4, y: 4}
      ], [
        {x: 0, y: 0},
        {x: 1, y: 0},
        {x: 4, y: 0},
        {x: 2, y: 1},
        {x: 3, y: 1},
        {x: 2, y: 2},
        {x: 2, y: 3},
        {x: 3, y: 3},
        {x: 0, y: 4},
        {x: 1, y: 4},
        {x: 4, y: 4}
      ], [
        {x: 0, y: 0},
        {x: 4, y: 0},
        {x: 1, y: 1},
        {x: 3, y: 1},
        {x: 1, y: 2},
        {x: 2, y: 2},
        {x: 3, y: 2},
        {x: 0, y: 3},
        {x: 4, y: 3},
        {x: 0, y: 4},
        {x: 4, y: 4}
      ]
    ],
    chess: [
      [
        {x: 0, y: 0},
        {x: 2, y: 0},
        {x: 4, y: 0},
        {x: 1, y: 1},
        {x: 3, y: 1},
        {x: 0, y: 2},
        {x: 2, y: 2},
        {x: 4, y: 2},
        {x: 1, y: 3},
        {x: 3, y: 3},
        {x: 0, y: 4},
        {x: 2, y: 4},
        {x: 4, y: 4}
      ]
    ],
    s3: [
      [
        {x: 0, y: 0},
        {x: 0, y: 1},
        {x: 3, y: 1},
        {x: 0, y: 2},
        {x: 1, y: 2},
        {x: 2, y: 2},
        {x: 3, y: 2},
        {x: 4, y: 2},
        {x: 1, y: 3},
        {x: 4, y: 3},
        {x: 4, y: 4}
      ], [
        {x: 4, y: 0},
        {x: 1, y: 1},
        {x: 4, y: 1},
        {x: 0, y: 2},
        {x: 1, y: 2},
        {x: 2, y: 2},
        {x: 3, y: 2},
        {x: 4, y: 2},
        {x: 0, y: 3},
        {x: 3, y: 3},
        {x: 0, y: 4}
      ]
    ],
    a: [
      [
        {x: 1, y: 0},
        {x: 0, y: 1},
        {x: 2, y: 1},
        {x: 0, y: 2},
        {x: 1, y: 2},
        {x: 2, y: 2},
        {x: 0, y: 3},
        {x: 2, y: 3},
        {x: 0, y: 4},
        {x: 2, y: 4}
      ]
    ],
    o: [
      [
        {x: 1, y: 0},
        {x: 0, y: 1},
        {x: 2, y: 1},
        {x: 0, y: 2},
        {x: 2, y: 2},
        {x: 0, y: 3},
        {x: 2, y: 3},
        {x: 1, y: 4}
      ]
    ],
    l: [
      [
        {x: 0, y: 0},
        {x: 0, y: 1},
        {x: 0, y: 2},
        {x: 0, y: 3},
        {x: 0, y: 4},
        {x: 1, y: 4},
        {x: 2, y: 4}
      ]
    ]
}

end