// =========================================================================
// ENTERPRISE ARCHITECTURE INTEGRATION STANDARD - SPECIFICATION FILE
// FILE: blood_bank_brackets.scad (Barbette No. 1 Whole Blood Bank Matrix)
// LICENSE: Boost Software License (BSL-1.0)
// =========================================================================

$fn = 100; // Force high-fidelity geometric rendering resolution

// --- Core Storage Slot Dimensions (mm) ---
tray_slot_w         = 320.0;   // Width of individual blood storage tray (32cm)
tray_slot_d         = 450.0;   // Depth of individual blood storage tray (45cm)
tray_slot_h         = 180.0;   // Height of individual slot compartment (18cm)
brace_thickness     = 25.0;    // Thick reinforced aluminum structural walls
retention_pin_r     = 12.0;    // Radius of heavy physical locking pin channel

// --- Array Configuration Density ---
grid_cols           = 4;       // Number of structural columns per rack block
grid_rows           = 6;       // Number of storage rows stacked vertically

module Blood_Bank_Brace_Bracket(w=tray_slot_w, d=tray_slot_d, h=tray_slot_h, t=brace_thickness) {
    difference() {
        // 1. Primary Structural Body: Cast Aluminum-Magnesium Support Core
        cube([w + (2 * t), d, h + (2 * t)], center=true);
        
        // 2. Central Storage Vault Void: Slide-Out Tray Envelope
        cube([w, d + 2, h], center=true);
        
        // 3. Weight-Reduction / Thermal-Airflow Side Ports
        // Allows Peltier +4°C regulated convection air currents to circulate uniformly
        rotate([0, 90, 0])
            cylinder(h=w + (2 * t) + 4, r=h * 0.3, center=true);
            
        // 4. Rear Pneumatic Ejection Line Port
        translate([0, d/2, 0])
            rotate([90, 0, 0])
                cylinder(h=t + 2, r=20, center=true);
                
        // 5. Front Dual Locking-Pin Channels (Sig Sauer-Inspired Mechanical Retention)
        // Secures blood transport cases during intense hydrodynamic maneuvers
        for (side = [-1, 1]) {
            translate([side * (w/2 + t/2), -d/2 + 50, 0])
                rotate([0, 0, 0])
                    cylinder(h=h + (2 * t) + 4, r=retention_pin_r, center=true);
        }
    }
}

module Integrated_Barbette_Storage_Grid(cols=grid_cols, rows=grid_rows) {
    // Computes the cumulative physical steps for three-dimensional modular array tiling
    x_step = tray_slot_w + brace_thickness;
    z_step = tray_slot_h + brace_thickness;
    
    translate([-(cols - 1) * x_step / 2, 0, -(rows - 1) * z_step / 2]) {
        for (col_idx = [0 : cols - 1]) {
            for (row_idx = [0 : rows - 1]) {
                translate([col_idx * x_step, 0, row_idx * z_step])
                    Blood_Bank_Brace_Bracket();
            }
        }
    }
}

// --- Master Assembly Compilation Instance ---
// Instantiates a unified 4x6 grid inside the Barbette No. 1 structural ring
Integrated_Barbette_Storage_Grid();
