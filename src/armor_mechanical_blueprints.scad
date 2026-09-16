// =========================================================================
// SPECIFICATION FILE: mechanical_blueprints.scad
// DESCRIPTION: Form-Fitting E-CMF OtterBox Armor & Mechanical Pockets
// LICENSE: Boost Software License (BSL-1.0)
// =========================================================================

$fn = 120; // Forced high-fidelity rendering resolution

// --- Hull & Armor Sleeve Dimensions (mm) ---
montana_beam_w       = 38000.0; // 38.0-meter baseline hull beam width
montana_length       = 280000.0;// 280.0-meter master hull length
armor_thickness      = 750.0;   // 0.75-meter thick rubberized metal-foam shield
vortex_core_diameter = 12500.0; // 12.5-meter inner resonance stack core

// --- Actuator & Spring Subsystems (mm) ---
piston_rod_diameter  = 450.0;   // Solid Titanium (Ti-6Al-4V) core
cylinder_bore_r      = 350.0;   // 700mm cylinder internal bore radius
spring_wire_d        = 75.0;    // Heavy-caliber multi-strand wire thickness

module Form_Fitting_Armor_Sleeve(b=montana_beam_w, l=montana_length, t=armor_thickness) {
    // Generates the outer, blunt "tugboat-style" protective composite shell
    difference() {
        // Outer boundary layer including the E-CMF matrix skin
        scale([1.1, 1.05, 1.0])
            cylinder(h=22000, r1=b/2 + t, r2=b/1.5 + t, center=true);
        // Interior structural cutout form-fitted to wrap tightly around the inner hull
        scale([1.0, 1.0, 1.0])
            cylinder(h=22010, r1=b/2, r2=b/1.5, center=true);
    }
}

module Surgical_Citadel_Recoil_Spring(barbette_r=6200, wire_d=spring_wire_d, turns=14) {
    // Sig Sauer-Inspired Multi-Strand Recoil Spring Isolation Matrix
    // Suspends surgical decks inside armored barbettes to absorb hull blast impact
    union() {
        for (i = [0 : turns * 100]) {
            angle = i * 3.6;
            z_axis = (i / 100) * (wire_d * 1.1);
            translate([barbette_r * cos(angle), barbette_r * sin(angle), z_axis - (turns * wire_d / 2)])
                sphere(r=wire_d/2);
        }
    }
}

module Keel_Hydraulic_Actuator_Pocket(r_bore=cylinder_bore_r, d_rod=piston_rod_diameter) {
    difference() {
        // High-tensile cast steel mounting frame anchor block
        cube([1200, 1200, 2200], center=true);
        // Forged internal cylinder casing cavity
        cylinder(h=2000, r=r_bore, center=true);
        // Lower clearance guide passage for the movable titanium rod
        translate([0, 0, -400])
            cylinder(h=2210, r=(d_rod/2) + 15, center=true);
    }
}

module Cryo_Vault_Sliding_Brackets(slots=8, spacing=120) {
    // Generates precision CNC milled tracks for slide-out blood plasma shelves
    difference() {
        cube([610, 800, slots * spacing + 50], center=true);
        cube([550, 802, slots * spacing + 10], center=true);
        for (i = [0 : slots - 1]) {
            translate([0, 0, (i * spacing) - ((slots * spacing)/2) + (spacing/2)])
                cube([630, 804, 20], center=true);
        }
    }
}

// Render configuration map for verification check
translate([-45000, 0, 0])    Form_Fitting_Armor_Sleeve();
translate([45000, 0, 0])     Surgical_Citadel_Recoil_Spring();
translate([0, -30000, 0])    Keel_Hydraulic_Actuator_Pocket();
translate([0, 30000, 0])     Cryo_Vault_Sliding_Brackets();
