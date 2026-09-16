// =========================================================================
// SPECIFICATION FILE: mechanical_blueprints.scad (Armor Sleeve Extension)
// DESCRIPTION: Interlocking High-Pressure Oil Seal Arrays & Actuator Geometry
// =========================================================================

$fn = 120; // Forced high-fidelity rendering resolution

// --- Extended Mechanical Dimensions (mm) ---
cylinder_bore_outer_r  = (700 / 2) + 50;  // 700mm bore radius + 50mm steel wall thickness
clevis_flange_width    = 900.0;           // Total footprint width of the anchoring flange
pocket_depth           = 2200.0;          // Total structural recess depth into keel plates
seal_ring_width        = 25.0;            // Width of the synthetic compression rings
seal_count             = 4;               // Quad-stage hermetic barrier layout

module High_Pressure_Seal_Groove(r_bore=350, z_offset=0, w=seal_ring_width) {
    // CNC-milled channel parameters for the natural rubber expansion boots
    translate([0, 0, z_offset])
        difference() {
            cylinder(h=w, r=r_bore + 10, center=true);
            cylinder(h=w + 2, r=r_bore - 1, center=true);
        }
}

module Keel_Hydraulic_Actuator_Pocket(r_bore=cylinder_bore_outer_r, f_w=clevis_flange_width, d=pocket_depth) {
    difference() {
        // 1. Primary Structural Mass Block: Cast Steel Keel Section
        translate([-f_w/2, -f_w/2, -d/2])
            cube([f_w, f_w, d], center=false);
        
        // 2. Central Cylinder Recess Casing Void
        translate([0, 0, 100])
            cylinder(h=d + 20, r=350, center=true);
            
        // 3. Lower Extension Passage (Passage for the 450mm Titanium Rod)
        translate([0, 0, -d/2])
            cylinder(h=d + 2, r=(450 / 2) + 20, center=true);
            
        // 4. Quad-Stage Interlocking High-Pressure Oil Seal Tracks
        for (i = [0 : seal_count - 1]) {
            High_Pressure_Seal_Groove(r_bore=350, z_offset=(i * 60) - (d/4), w=seal_ring_width);
        }
        
        // 5. Anchor Fastener Ring (12x Sub-Structural Threaded Mounting Holes)
        for (j = [0 : 11]) {
            rotate([0, 0, j * 30])
                translate([350 + 60, 0, d/2 - 100])
                    cylinder(h=152, r=24, center=true); // 48mm heavy fasteners
        }
    }
}

// Render compilation segment for pipeline test
Keel_Hydraulic_Actuator_Pocket();
