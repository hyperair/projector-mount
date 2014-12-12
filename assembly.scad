import ("ceiling-plate.stl");

translate ([0, 0, 16])
import ("swivel.stl");

translate ([0, -28/2, 64])
rotate ([-90, 0, 0])
import ("../ProjectorUniversal2.stl");

translate ([0, 0, 87])
rotate (180, [1, 0, 0])
translate ([-94.0166667, -35.5033, 0])
import ("projector-plate.stl");
